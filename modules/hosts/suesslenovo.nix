# Host declaration for suesslenovo — Justin's laptop.
# Composes NixOS feature modules from `config.flake.nixosModules` and wires them
# into `configurations.nixos.suesslenovo.module` (picked up by `modules/nixos.nix`).
{ config, inputs, ... }:
let
  nixos = config.flake.nixosModules;
in
{
  configurations.nixos.suesslenovo.module = {
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
            "xhci_pci"
            "thunderbolt"
            "nvme"
            "usb_storage"
            "sd_mod"
            "sdhci_pci"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-intel" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/c403879a-a3eb-48cd-881b-bbae94b43886";
            fsType = "ext4";
          };

          boot.initrd.luks.devices."luks-a6f77515-b8cd-440c-89b0-ba95b1710dcc".device =
            "/dev/disk/by-uuid/a6f77515-b8cd-440c-89b0-ba95b1710dcc";

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/62E2-2ADC";
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
            brightnessctl.enable = true;
            kwallet.enable = true;
            battery.enable = true;
            stylix.enable = true;
            bluedevil.enable = true;
            pinpam.enable = true;
            dolphin.enable = true;
            qflipper.enable = true;
            signal-desktop.enable = true;
            virt-manager.enable = true;
            devtools.enable = true;
            ghidra-bin.enable = true;
            okteta.enable = true;
          };

          networking.hostName = "suesslenovo";

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

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

          environment.systemPackages = with pkgs; [ mpv ];

          hardware.graphics.enable = true;

          nix.settings = {
            substituters = [ "s3://nix?endpoint=s3.prizrak.me&region=us-east-1&profile=default" ];
            trusted-public-keys = [ "prizrak.me:Hk9hSoa/uKOc4cEu8Tu7a4XRkkG08HBs8fQC6nhcuds=" ];
            builders-use-substitutes = true;
          };

          nix.trustedUsers = [
            config.my.user.name
            "root"
          ];

          sops = {
            defaultSopsFile = ./suesslenovo.secrets.yaml;
            age.keyFile = "/etc/age/key.txt";
            templates."nix-aws.env" = {
              owner = "root";
              mode = "0400";
              content = ''
                AWS_ACCESS_KEY_ID=${config.sops.placeholder."s3/access_key_id"}
                AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."s3/secret_access_key"}
                AWS_ENDPOINT_URL_S3=https://s3.prizrak.me
                AWS_EC2_METADATA_DISABLED=true
                AWS_PROFILE=default
              '';
            };
            secrets = {
              "s3/access_key_id" = {
                owner = config.my.user.name;
                mode = "0400";
              };
              "s3/secret_access_key" = {
                owner = config.my.user.name;
                mode = "0400";
              };
              "nix/builder_ssh_key" = {
                owner = "root";
                path = "/root/.ssh/remote-builder-id_ed25519";
                mode = "0400";
              };
            };
          };

          systemd.services.nix-daemon.serviceConfig.EnvironmentFile = lib.mkAfter [
            config.sops.templates."nix-aws.env".path
          ];

          nix.buildMachines = [
            {
              hostName = "princessbelongsto.me";
              system = "x86_64-linux";
              protocol = "ssh-ng";
              sshUser = "root";
              sshKey = "/root/.ssh/remote-builder-id_ed25519";
              maxJobs = 4;
              speedFactor = 2;
              supportedFeatures = [
                "big-parallel"
                "kvm"
                "nixos-test"
                "benchmark"
              ];
              mandatoryFeatures = [ ];
            }
          ];

          nix.distributedBuilds = true;

          nix.extraOptions = ''
            	  builders-use-substitutes = true
            	'';

          programs.ssh.extraConfig = ''
            Host princessbelongsto.me
              Port 22223
              User root
              IdentityFile /root/.ssh/remote-builder-id_ed25519
          '';

          networking.firewall.allowedTCPPorts = [ 22 ];
          networking.firewall.allowedUDPPorts = [ 51820 ];

          system.stateVersion = "25.11";
        }
      )
    ];
  };
}
