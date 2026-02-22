{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.brightnessctl.enable {
    environment.systemPackages = [ pkgs.brightnessctl ];
  };
}
