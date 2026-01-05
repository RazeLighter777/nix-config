{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.mutt.enable {
    environment.systemPackages = [ pkgs.mutt pkgs.mutt-wizard ];
  };
}
