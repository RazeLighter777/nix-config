{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.commonKernel;
in
{
  options.my.commonKernel.enable = lib.mkEnableOption "Enable shared kernel defaults";

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_19;
  };
}
