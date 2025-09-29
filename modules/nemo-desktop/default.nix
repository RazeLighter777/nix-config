{ config, pkgs, ... }:
{
  home-manager.users.${config.my.user.name}.xdg.desktopEntries.nemo = {
    name = "Nemo"; exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };
  home-manager.users.${config.my.user.name}.xdg.mimeApps = {
    enable = true; defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
    };
  };
}
