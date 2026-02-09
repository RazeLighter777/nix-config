{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  services.openssh.enable = true;
  # Provide a base firewall rule set; hosts can extend via ++ or override using mkForce.
  networking.firewall.allowedTCPPorts = lib.mkDefault [
    22
    8080
    2222
  ];
  networking.firewall.allowedUDPPorts = lib.mkDefault [ 51820 ];
}
