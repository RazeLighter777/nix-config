{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.customKernel;
in
{

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      boot.kernelPackages = lib.mkForce (let
        linux_landlock_pkg = { fetchFromGitHub, buildLinux, ... } @ args:
          buildLinux (args // rec {
            version = "6.18.0-rc6-next";
            modDirVersion = "6.18.0-rc2-next-20251024";

            src = fetchFromGitHub {
              owner = "RazeLighter777";
              repo = "linux-landlock-no-inherit";
              rev = "wip";
              hash = "sha256-19+F5Mgp6m/bpndc87oKQoPAZmh3aHvEXM4WaBBEdG4=";
            };

            kernelPatches = [];

            # Use defconfig as base, then override with our options
            # This avoids interactive configuration questions
            autoModules = true;
            ignoreConfigErrors = true;
            
            # Only override the specific options we want to change
            structuredExtraConfig = with lib.kernel; {
              # Landlock LSM support
              SECURITY_LANDLOCK = yes;
              
              # Debug options
              DEBUG_INFO = yes;
              DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = yes;
              DEBUG_KERNEL = yes;
              DEBUG_FS = yes;
              
              # Additional useful debug options
              KALLSYMS = yes;
              KALLSYMS_ALL = yes;
            };

            extraMeta.branch = "6.18";
          } // (args.argsOverride or {}));
        
        linux_landlock = pkgs.callPackage linux_landlock_pkg {};
      in 
        lib.recurseIntoAttrs (pkgs.linuxPackagesFor linux_landlock));

      # Inherit kernel parameters from common-kernel if it's enabled
      boot.kernelParams = lib.mkIf config.my.commonKernel.enable [
        "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
      ];
    })
    {
      assertions = [
        {
          assertion = !(cfg.enable && config.my.nvidia.enable);
          message = "NVIDIA proprietary drivers are incompatible with the custom linux-next kernel (6.18-rc6). Either disable my.customKernel.enable or disable my.nvidia.enable.";
        }
      ];
    }
  ];
}
