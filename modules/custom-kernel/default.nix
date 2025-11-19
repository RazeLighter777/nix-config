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
  options.my.customKernel.enable = lib.mkEnableOption "Enable custom linux-landlock-no-inherit kernel";

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = let
      linux_landlock_pkg = { fetchFromGitHub, buildLinux, ... } @ args:
        buildLinux (args // rec {
          version = "6.12.0-landlock";
          modDirVersion = "6.12.0";

          src = fetchFromGitHub {
            owner = "RazeLighter777";
            repo = "linux-landlock-no-inherit";
            rev = "wip"; # or specify a specific commit hash
            hash = ""; # Will need to be filled after first build attempt
          };

          kernelPatches = [];

          # Inherit NixOS kernel defaults and add Landlock + debug options
          structuredExtraConfig = with lib.kernel; {
            # Landlock LSM support
            SECURITY_LANDLOCK = yes;
            
            # Debug options
            DEBUG_INFO = yes;
            DEBUG_INFO_DWARF4 = yes;
            DEBUG_KERNEL = yes;
            DEBUG_FS = yes;
            
            # Additional useful debug options
            FRAME_POINTER = yes;
            KALLSYMS = yes;
            KALLSYMS_ALL = yes;
          };

          extraMeta.branch = "6.12";
        } // (args.argsOverride or {}));
      
      linux_landlock = pkgs.callPackage linux_landlock_pkg {};
    in 
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_landlock);

    # Inherit kernel parameters from common-kernel if it's enabled
    boot.kernelParams = lib.mkIf config.my.commonKernel.enable [
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
    ];
  };
}
