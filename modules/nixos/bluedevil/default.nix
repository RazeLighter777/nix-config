{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.bluedevil.enable {
    environment.systemPackages = [ pkgs.kdePackages.bluedevil ];
  };
}
