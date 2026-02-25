# Shared NixOS options and default values consumed by all host configurations.
# Registered as `flake.nixosModules.options` by `modules/nixos/default.nix`.
{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.my = {
    user.name = mkOption {
      type = types.str;
      default = "justin";
      description = "Primary (single) user account name used by home-manager modules.";
    };
    user.homeDir = mkOption {
      type = types.str;
      description = "Home directory path for the primary user.";
    };
    homeManager.enable = mkEnableOption "Enable home-manager integration";
    displayManager.enable = mkEnableOption "Enable SDDM autologin for Hyprland (Hyprlock becomes the only login screen)";
    dolphin.enable = mkEnableOption "Enable Dolphin file manager";
    wine.enable = mkEnableOption "Enable Wine packages";
    ollama.enable = mkEnableOption "Enable Ollama service (CUDA)";
    protonup.enable = mkEnableOption "Enable protonup-ng tool";
    obs.enable = mkEnableOption "Enable OBS Studio with plugins";
    waybar.enable = mkEnableOption "Enable Waybar configuration";
    neovim.enable = mkEnableOption "Enable Neovim configuration";
    firefox.enable = mkEnableOption "Enable Firefox configuration";
    firefox.vanilla.enable = mkEnableOption "Enable vanilla Firefox profile (no extensions/customizations)";
    thunderbird.enable = mkEnableOption "Enable Thunderbird email client";
    ark.enable = mkEnableOption "Enable Ark archive manager";
    hyprland.enable = mkEnableOption "Enable Hyprland home-manager configuration";
    rofi.enable = mkEnableOption "Enable Rofi launcher configuration";
    mako.enable = mkEnableOption "Enable Mako notification daemon";
    bash.enable = mkEnableOption "Enable Bash configuration";
    dconf.enable = mkEnableOption "Enable dconf settings";
    vscode.enable = mkEnableOption "Enable VSCode configuration";
    kde.enable = mkEnableOption "Enable KDE Plasma desktop";
    nvidia.enable = mkEnableOption "Enable NVIDIA drivers and related settings";
    remmina.enable = mkEnableOption "Enable Remmina remote desktop client";
    freerdp.enable = mkEnableOption "Enable FreeRDP client";
    gnupg.enable = mkEnableOption "Enable gpg agent";
    kleopatra.enable = mkEnableOption "Enable Kleopatra certificate manager";
    nwg-display.enable = mkEnableOption "Enable nwg-display";
    libreoffice.enable = mkEnableOption "Enable libreoffice";
    okular.enable = mkEnableOption "Enable Okular PDF viewer";
    flatpak.enable = mkEnableOption "Enable flatpaks";
    screen.enable = mkEnableOption "Enable screen";
    brightnessctl.enable = mkEnableOption "Enable brightness";
    kwallet.enable = mkEnableOption "KWallet (replaces gnome-keyring/seahorse)";
    battery.enable = mkEnableOption "Battery support";
    kitty.enable = mkEnableOption "Kitty terminal";
    udiskie.enable = mkEnableOption "Udiskie";
    stylix.enable = mkEnableOption "Enable Stylix tiling window manager";
    xdg-apps.enable = mkEnableOption "Enable custom XDG MIME applications";
    bluedevil.enable = mkEnableOption "Enable BlueDevil Bluetooth manager";
    wayvnc.enable = mkEnableOption "Enable WayVNC server for Hyprland";
    virt-manager.enable = mkEnableOption "Enable QEMU and Virtual Machine Manager";
    xwayland.enable = mkEnableOption "Enable XWayland support";
    pinpam.enable = mkEnableOption "Enable PIN and PAM integration";
    discord.enable = mkEnableOption "Enable Discord configuration";
    customKernel.enable = mkEnableOption "Enable custom linux-landlock-no-inherit kernel";
    calibre.enable = mkEnableOption "Enable Calibre eBook manager";
    shattered-pixel-dungeon.enable = mkEnableOption "Enable Shattered Pixel Dungeon game";
    qflipper.enable = mkEnableOption "Enable qFlipper";
    spotify.enable = mkEnableOption "Enable Spotify";
    signal-desktop.enable = mkEnableOption "Enable Signal Desktop messaging app";
    devtools.enable = mkEnableOption "Enable development tools";
    zoom-us.enable = mkEnableOption "Enable Zoom video conferencing";
    bitwarden.enable = mkEnableOption "Enable Bitwarden (desktop + CLI)";
    ssh-agent.enable = mkEnableOption "Enable SSH agent systemd user unit";
    ghidra-bin.enable = mkEnableOption "Enable Ghidra (binary distribution)";
    okteta.enable = mkEnableOption "Enable Okteta hex editor";
  };

  config = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    my = {
      # Defaults: most user applications enabled unless explicitly disabled in a host.
      homeManager.enable = lib.mkDefault true;
      dolphin.enable = lib.mkDefault true;
      wine.enable = lib.mkDefault true;
      protonup.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
      thunderbird.enable = lib.mkDefault true;
      ark.enable = lib.mkDefault true;
      bash.enable = lib.mkDefault true;
      dconf.enable = lib.mkDefault true;
      vscode.enable = lib.mkDefault true;
      mako.enable = lib.mkDefault config.my.hyprland.enable;
      fontsLocale.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
      steam.enable = lib.mkDefault true;
      plymouth.enable = lib.mkDefault true;
      commonKernel.enable = lib.mkDefault true;
      pipewire.enable = lib.mkDefault true;
      smartcards.enable = lib.mkDefault true;
      dodCerts.enable = lib.mkDefault true;
      remmina.enable = lib.mkDefault true;
      freerdp.enable = lib.mkDefault true;
      gnupg.enable = lib.mkDefault true;
      kleopatra.enable = lib.mkDefault true;
      nwg-display.enable = lib.mkDefault true;
      libreoffice.enable = lib.mkDefault true;
      okular.enable = lib.mkDefault true;
      flatpak.enable = lib.mkDefault true;
      screen.enable = lib.mkDefault true;
      brightnessctl.enable = lib.mkDefault false;
      kwallet.enable = lib.mkDefault false;
      battery.enable = lib.mkDefault false;
      kitty.enable = lib.mkDefault true;
      udiskie.enable = lib.mkDefault true;
      stylix.enable = lib.mkDefault false;
      xdg-apps.enable = lib.mkDefault true;
      bluedevil.enable = lib.mkDefault false;
      wayvnc.enable = lib.mkDefault false;
      virt-manager.enable = lib.mkDefault false;
      xwayland.enable = lib.mkDefault true;
      pinpam.enable = lib.mkDefault false;
      print.enable = lib.mkDefault true;
      discord.enable = lib.mkDefault true;
      customKernel.enable = lib.mkDefault false;
      calibre.enable = lib.mkDefault false;
      shattered-pixel-dungeon.enable = lib.mkDefault true;
      qflipper.enable = lib.mkDefault false;
      scx.enable = lib.mkDefault true;
      spotify.enable = lib.mkDefault true;
      devtools.enable = lib.mkDefault false;
      zoom-us.enable = lib.mkDefault true;
      bitwarden.enable = lib.mkDefault true;
      ssh-agent.enable = lib.mkDefault true;
      ghidra-bin.enable = lib.mkDefault false;
      okteta.enable = lib.mkDefault false;

      # Enable Rofi automatically when Hyprland is enabled.
      rofi.enable = lib.mkDefault config.my.hyprland.enable;

      # Derived values (not options): convenience for other modules.
      user.homeDir = "/home/${config.my.user.name}";
    };
    assertions = [
      {
        assertion = !(config.my.hyprland.enable && config.my.kde.enable);
        message = "Cannot enable both Hyprland and KDE simultaneously.";
      }
      {
        assertion = !(config.my.displayManager.enable && config.my.kde.enable);
        message = "This displayManager module is Hyprland-specific; disable it when using KDE (Plasma).";
      }
    ];
  };
}
