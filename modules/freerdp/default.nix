{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.freerdp.enable {
    environment.systemPackages = [ pkgs.freerdp ];
  };
}
