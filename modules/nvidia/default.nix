{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.initrd.kernelModules = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
