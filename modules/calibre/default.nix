{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.gnome-keyring.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = [ pkgs.calibre ];
    };
  };
}
