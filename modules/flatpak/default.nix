{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.flatpak.enable {
    services.flatpak.enable = true;
  };
}
