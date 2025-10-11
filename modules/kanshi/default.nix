{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.kanshi.enable {
    environment.systemPackages = [ pkgs.kanshi ];
  };
}
