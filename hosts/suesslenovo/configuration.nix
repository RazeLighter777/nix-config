{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ../../modules ];
  my = {
    hyprland.enable = true;
    displayManager.enable = true;
    waybar.enable = true;
    # Rely on mkDefault for rest (no NVIDIA / OBS / XMRig)
  };
  networking.hostName = "suesslenovo";
  boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true;
  # Kernel base config + plymouth handled by my.commonKernel / my.plymouth
  # Timezone, locale, direnv now provided by common module (override here if needed)
  users.users.${config.my.user.name} = { isNormalUser = true; description = "${config.my.user.name}"; extraGroups = [ "networkmanager" "wheel" "docker" "video" "dialout" "tty" ]; };
  # Host-specific extra packages beyond common + hyprland extras
  environment.systemPackages = with pkgs; [ mpv ];
  hardware.graphics.enable = true;
  # SSH enabled via networking module
  # NetworkManager enabled in networking module
  networking.firewall.allowedTCPPorts = [ 22 5900 8080 9999 5173 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  system.stateVersion = "25.05";
  # Docker enabled via docker module
  # Steam enabled via my.steam module
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.87.6/32" ]; listenPort = 51820;
  privateKeyFile = "${config.my.user.homeDir}/Keys/peer_suesslenovo.key"; # placeholder
  peers = [{ publicKey = "REPLACE_SERVER_PUBKEY=="; presharedKeyFile = "${config.my.user.homeDir}/Keys/peer_A-peer_suesslenovo.psk"; allowedIPs = [ "192.168.87.0/24" ]; endpoint = "edge.prizrak.me:51820"; persistentKeepalive = 25; }];
  };
}
