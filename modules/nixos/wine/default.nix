{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.wine.enable {
    environment.systemPackages = with pkgs; [
      wine
      wine64
      winetricks
    ];
  };
}
