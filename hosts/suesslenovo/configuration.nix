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
    kwallet.enable = true;
    battery.enable = true;
    stylix.enable = true;
    bluedevil.enable = true;
    networkmanager-qt.enable = true;
    pinpam.enable = true;
    dolphin.enable = true;
    qflipper.enable = true;
    signal-desktop.enable = true;
    opensnitch.enable = true;
    clamav.enable = true;
    tracee.enable = false;
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
  system.stateVersion = "25.11";
  # Docker enabled via docker module
  # Steam enabled via my.steam module
}
