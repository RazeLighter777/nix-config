{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.kwallet.enable {
    environment.systemPackages = [ pkgs.kdePackages.kwallet pkgs.kdePackages.kwalletmanager ];
  };
}
