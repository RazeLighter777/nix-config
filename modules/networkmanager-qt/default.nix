{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.networkmanager-qt.enable {
    environment.systemPackages = [ pkgs.kdePackages.networkmanager-qt ];
  };
}
