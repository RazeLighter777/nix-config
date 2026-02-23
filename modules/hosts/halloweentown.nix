# Host declaration for halloweentown — Michelle's laptop.
# Composes NixOS feature modules from `config.flake.nixosModules` and wires them
# into `configurations.nixos.halloweentown.module` (picked up by `modules/nixos.nix`).
{ config, inputs, ... }:
let
  nixos = config.flake.nixosModules;
in
{
  configurations.nixos.halloweentown.module = {
    imports = [
      # Shared options (my.*) and default enable values.
      nixos.options
      # System-level feature modules.
      nixos.common
      nixos.networking
      nixos.podman
      nixos.fonts-locale
      nixos.bluetooth
      nixos.steam
      nixos.plymouth
      nixos.common-kernel
      nixos.custom-kernel
      nixos.pipewire
      nixos.power-profiles-daemon
      nixos.home-manager
      nixos.display-manager
      nixos.dolphin
      nixos.wine
      nixos.ollama
      nixos.protonup
      nixos.obs
      nixos.waybar
      nixos.neovim
      nixos.firefox
      nixos.thunderbird
      nixos.ark
      nixos.xdg-apps
      nixos.hyprland
      nixos.hyprland-extra
      nixos.rofi
      nixos.mako
      nixos.bash
      nixos.dconf
      nixos.vscode
      nixos.kde
      nixos.kde-extra
      nixos.nvidia
      nixos.smartcards
      nixos.dod-certs
      nixos.remmina
      nixos.freerdp
      nixos.gnupg
      nixos.kleopatra
      nixos.nwg-display
      nixos.libreoffice
      nixos.okular
      nixos.flatpak
      nixos.screen
      nixos.brightnessctl
      nixos.kwallet
      nixos.kitty
      nixos.udiskie
      nixos.stylix
      nixos.bluedevil
      nixos.wayvnc
      nixos.virt-manager
      nixos.xwayland
      nixos.pinpam
      nixos.print
      nixos.hyprlock
      nixos.discord
      nixos.calibre
      nixos.shattered-pixel-dungeon
      nixos.qflipper
      nixos.scx
      nixos.spotify
      nixos.signal-desktop
      nixos.devtools
      nixos.zoom-us
      nixos.bitwarden
      nixos.ssh-agent
      nixos.systemd-sandboxing
      nixos.ghidra-bin
      nixos.okteta
      # Hardware-specific module (previously hosts/halloweentown/hardware-configuration.nix).
      (
        {
          config,
          lib,
          pkgs,
          modulesPath,
          ...
        }:
        {
          imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

          boot.initrd.availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usb_storage"
            "sd_mod"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-intel" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/7135dd1d-5cfd-4fb8-ba7b-cb0032fe8725";
            fsType = "ext4";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/2D36-4B22";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };

          swapDevices = [ ];

          networking.useDHCP = lib.mkDefault true;

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        }
      )

      # Host-specific NixOS configuration (previously hosts/halloweentown/configuration.nix).
      (
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          my = {
            user.name = "michelle";
            kde.enable = true;
            nvidia.enable = true;
            pinpam.enable = true;
            firefox.vanilla.enable = true;
          };

          networking.hostName = "halloweentown";

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

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

          environment.systemPackages = with pkgs; [ mpv ];

          networking.firewall.allowedTCPPorts = [
            22
            8080
          ];
          networking.firewall.allowedUDPPorts = [ 51820 ];

          system.stateVersion = "25.11";
        }
      )
    ];
  };
}
