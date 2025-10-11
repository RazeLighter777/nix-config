{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.libreoffice.enable {
    system.packages =
      [ ]
      ++ lib.mkIf config.my.kde.enable [ pkgs.libreoffice-qt6-fresh ]
      ++ lib.mkIf config.my.hyprland.enable [ pkgs.libreoffice-fresh ];

  };
}
