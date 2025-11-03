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
    waybar.enable = true;
    brightnessctl.enable = true;
    # Rely on mkDefault for rest (no NVIDIA / OBS / XMRig)
    gnome-keyring.enable = true;
    battery.enable = true;
    stylix.enable = true;
    blueberry.enable = true;
    pinpam.enable = true;
  };
  networking.hostName = "suesslenovo";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Kernel base config + plymouth handled by my.commonKernel / my.plymouth
  # Timezone, locale, direnv now provided by common module (override here if needed)
  users.users.${config.my.user.name} = {
    isNormalUser = true;
    description = "${config.my.user.name}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "dialout"
      "tty"
    ];
  };
  # Host-specific extra packages beyond common + hyprland extras
  environment.systemPackages = with pkgs; [ mpv ];
  hardware.graphics.enable = true;
  # SSH enabled via networking module
  # NetworkManager enabled in networking module
  networking.firewall.allowedTCPPorts = [
    22
  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  system.stateVersion = "25.05";
  # Docker enabled via docker module
  # Steam enabled via my.steam module
}
