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
      nixos.kav
      nixos.devtools
      nixos.zoom-us
      nixos.bitwarden
      nixos.ssh-agent
      nixos.systemd-sandboxing
      nixos.ghidra-bin
      nixos.okteta
      # Hardware-specific and external modules.
      ../../hosts/suesslenovo/hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
      # Host-specific NixOS configuration.
      ../../hosts/suesslenovo/configuration.nix
    ];
  };
}
