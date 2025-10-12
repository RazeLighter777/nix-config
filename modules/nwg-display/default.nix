{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.nwg-display.enable {
    environment.systemPackages = [ pkgs.nwg-display ];
  };
}
