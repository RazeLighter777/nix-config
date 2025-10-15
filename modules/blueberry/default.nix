{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.blueberry.enable {
    environment.systemPackages = [
        pkgs.blueberry
    ]
  };
}
