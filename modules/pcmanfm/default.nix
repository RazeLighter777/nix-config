{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.pcmanfm.enable {
    environment.systemPackages = [
      pkgs.pcmanfm
    ];
  };
}
