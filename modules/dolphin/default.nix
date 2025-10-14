{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.dolphin.enable {
    environment.systemPackages = [ pkgs.kdePackages.dolphin ];
  };
}
