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
    user.name = "michelle"; # host-specific primary user
    kde.enable = true; # choose KDE desktop
    nvidia.enable = true; # enable NVIDIA driver for this laptop
    pinutil.enable = true;
    # All standard applications pulled in via mkDefault
  };
  networking.hostName = "halloweentown";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Kernel packages handled by my.commonKernel module
  # Timezone & locale come from common (override above if needed)
  users.users.${config.my.user.name} = {
    isNormalUser = true;
    description = config.my.user.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  # Host-specific extra packages (on top of common + KDE extras)
  environment.systemPackages = with pkgs; [ mpv ];
  # NetworkManager & SSH enabled via networking module
  networking.firewall.allowedTCPPorts = [
    22
    8080
  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  system.stateVersion = "25.05";
  # Experimental features & docker via shared modules
}
