{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];
  my = {
    hyprland.enable = true;
    displayManager.enable = true;
    waybar.enable = true; # paired with Hyprland
    nvidia.enable = true; # Disabled - incompatible with custom kernel
    obs.enable = true; # optional GPU-accelerated app
    xmrig.enable = false; # explicitly opt-in (default false)
    # All other common apps come from mkDefault in modules/default.nix
    ollama.enable = true; # optional AI app
    gnome-keyring.enable = true;
    blueberry.enable = true;
    stylix.enable = true; # for color scheme management
    wayvnc.enable = true; # for remote desktop access
    pinpam.enable = true; # for managing PINs
    customKernel.enable = false;
    firefox.enable = true;
    pcmanfm.enable = true;
    qflipper.enable = true;
  };

  networking.hostName = "zenbox";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = lib.mkAfter [ "mitigations=off" ];
  # Kernel base config + plymouth handled by my.commonKernel / my.plymouth
  # Common services (nix-ld, networkmanager, locale/timezone, direnv) now handled by aggregated modules
  # Fonts & extra locale settings provided by my.fontsLocale module
  services.xserver.xkb.layout = "us";

  users.users.${config.my.user.name} = {
    isNormalUser = true;
    description = config.my.user.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "dialout"
      "tty"
    ];
    packages = [ ];
  };
  programs.nix-ld.enable = true;
  security.polkit.enable = true;
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    abrmd.enable = true;
  };

  boot.kernelModules = [
    "ntsync"
    # my wifi driver
    "rtw89_8852ce"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  # Host-specific packages layered on top of common + hyprland extras
  environment.systemPackages = with pkgs; [
    cloudflared
    screen
    arion
    mpv
    protonplus
  ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      libva-utils
    ];
  };
  # PipeWire + rtkit enabled via my.pipewire module
  networking.firewall.allowedTCPPorts = [
    22
    5900
    8080
    9999
    5173
  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  system.stateVersion = "25.11";
  # Experimental features & docker enabled in shared modules
  # Steam enabled via my.steam module
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.87.5/32" ];
    listenPort = 51820;
    privateKeyFile = "${config.my.user.homeDir}/Keys/peer_zenbox.key";
    peers = [
      {
        publicKey = "VzQMzZcTBQYrARnefqraQJuc6CVFf15ifUNsDuTV2wY=";
        presharedKeyFile = "${config.my.user.homeDir}/Keys/peer_A-peer_zenbox.psk";
        allowedIPs = [ "192.168.87.0/24" ];
        endpoint = "edge.prizrak.me:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
