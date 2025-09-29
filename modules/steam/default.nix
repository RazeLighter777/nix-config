{ config, lib, ... }:
let cfg = config.my.steam; in {
  options.my.steam.enable = lib.mkEnableOption "Enable Steam with open firewall rules for common features";
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
