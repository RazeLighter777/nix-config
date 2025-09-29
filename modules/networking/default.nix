{ config, lib, ... }:
{
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  # Provide a base firewall rule set; hosts can extend via ++ or override using mkForce.
  networking.firewall.allowedTCPPorts = lib.mkDefault [
    22
    8080
  ];
  networking.firewall.allowedUDPPorts = lib.mkDefault [ 51820 ];
}
