{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.libreoffice.enable {
    environment.systemPackages = [
      pkgs.libreoffice-qt6-fresh
    ];
  };
}
