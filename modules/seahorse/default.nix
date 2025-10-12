{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.gnome-keyring.enable {
    environment.systemPackages = [ pkgs.seahorse ];
  };
}
