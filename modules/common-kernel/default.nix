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
    boot.kernelPackages = pkgs.linuxPackages_6_17;
    boot.kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "udev.log_level=3"
      "boot.shell_on_fail"
    ];
    boot.consoleLogLevel = 0;
    boot.loader.timeout = 0;
    boot.initrd.verbose = false;
    boot.initrd.systemd.enable = true;
  };
}
