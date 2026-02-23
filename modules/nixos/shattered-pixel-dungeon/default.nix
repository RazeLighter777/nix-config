{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.shattered-pixel-dungeon.enable {
    environment.systemPackages = [ pkgs.shattered-pixel-dungeon ];
  };
}
