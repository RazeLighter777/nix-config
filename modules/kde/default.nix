{ config, lib, ... }:
{
  config = lib.mkIf config.my.kde.enable {
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };
}
