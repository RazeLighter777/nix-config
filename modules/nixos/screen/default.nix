{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.screen.enable {
    environment.systemPackages = [ pkgs.screen ];
  };
}
