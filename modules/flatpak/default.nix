{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.nemo.enable {
    services.flatpak.enable = true;
  };
}
