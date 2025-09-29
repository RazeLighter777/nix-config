{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.nemo.enable {
    environment.systemPackages = [ pkgs.nemo-with-extensions ];
  };
}
