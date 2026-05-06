{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.remmina.enable {
    environment.systemPackages = [ pkgs.remmina ];
  };
}
