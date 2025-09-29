{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.nemoDesktop.enable {
    home-manager.users.${config.my.user.name} = {
      xdg.desktopEntries.nemo = {
        name = "Nemo";
        exec = "${pkgs.nemo-with-extensions}/bin/nemo";
      };
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "nemo.desktop" ];
          "application/x-gnome-saved-search" = [ "nemo.desktop" ];
        };
      };
    };
  };
}
