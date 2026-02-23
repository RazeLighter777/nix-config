# Host declaration for zenbox — Justin's desktop.
# Composes NixOS feature modules from `config.flake.nixosModules` and wires them
# into `configurations.nixos.zenbox.module` (picked up by `modules/nixos.nix`).
{ config, inputs, ... }:
let
  nixos = config.flake.nixosModules;
in
{
  configurations.nixos.zenbox.module = {
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
      # Hardware-specific and external modules.
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
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-amd" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/a082b4a6-da76-4dbc-b1ee-3e7d03d13f5d";
            fsType = "xfs";
          };

          boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/04e00f6c-6043-442b-b400-6a5f6ecb4859";

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/EEB8-9F14";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };

          swapDevices = [ ];

          networking.useDHCP = lib.mkDefault true;
          hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        }
      )
      inputs.sops-nix.nixosModules.sops
      # Host-specific NixOS configuration.
      (
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          my = {
            hyprland.enable = true;
            displayManager.enable = true;
            waybar.enable = true;
            nvidia.enable = true;
            obs.enable = true;
            ollama.enable = true;
            kwallet.enable = true;
            bluedevil.enable = true;
            stylix.enable = true;
            wayvnc.enable = true;
            pinpam.enable = true;
            firefox.enable = true;
            dolphin.enable = true;
            qflipper.enable = true;
            signal-desktop.enable = true;
            virt-manager.enable = true;
            customKernel.enable = false;
            devtools.enable = true;
            ghidra-bin.enable = true;
            okteta.enable = true;
          };

          networking.hostName = "zenbox";

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.kernelParams = lib.mkAfter [ "mitigations=off" ];

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
            "rtw89_8852ce"
          ];

          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.allowUnfreePredicate = (_: true);

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

          networking.firewall.allowedTCPPorts = [
            22
            5900
            8080
            9999
            5173
            2222
          ];
          networking.firewall.allowedUDPPorts = [ 51820 ];

          system.stateVersion = "25.11";

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
      )
    ];
  };
}
