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
      boot.kernelPackages = lib.mkForce (
        let
          linux_landlock_pkg =
            { fetchFromGitHub, buildLinux, ... }@args:
            buildLinux (
              args
              // rec {
                version = "6.19.0";
                modDirVersion = "6.19.0";

                src = fetchFromGitHub {
                  owner = "torvalds";
                  repo = "linux";
                  rev = "master";
                  hash = "sha256-t9XYJObwSStTkMkU5tP66Orx5rrgwEuAtWbwrDyi/go=";
                };

                kernelPatches = [ ];

                # Use defconfig as base, then override with our options
                # This avoids interactive configuration questions
                autoModules = true;
                ignoreConfigErrors = true;

                extraMeta.branch = "master";
              }
              // (args.argsOverride or { })
            );

          linux_landlock = pkgs.callPackage linux_landlock_pkg { };
        in
        lib.recurseIntoAttrs (pkgs.linuxPackagesFor linux_landlock)
      );

      # Inherit kernel parameters from common-kernel if it's enabled
      boot.kernelParams = lib.mkIf config.my.commonKernel.enable [
        "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
      ];
    })
  ];
}
