{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.dconf.enable {
    home-manager.users.${config.my.user.name} = {
      dconf.settings = {
        "org/gnome/settings-daemon/plugins/power" = {
          ambient-enabled = false;
        };
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
    services.dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
      implementation = "broker";
    };
    programs.dconf = {
      enable = true;
    };

  };
}
