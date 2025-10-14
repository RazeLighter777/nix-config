{pkgs, config, ...}:
{
{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.xdg-apps.enable {
    home-manager.users.${config.my.user.name} = {
          xdg.mimeApps = {
    enable = true;
    defaultApplications = {
        "image/jpeg" = "swayim.desktop";
        "image/png" = "swayim.desktop";
        "image/gif" = "swayim.desktop";
        "text/plain" = "vim";
        "text/html" = "firefox.desktop";
        "application/pdf" = "zathura.desktop";
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "application/x-shellscript" = "vim";
    };

    };
  };
    };
  };
}