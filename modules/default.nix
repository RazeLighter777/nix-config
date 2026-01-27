{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    optional
    any
    mkOption
    types
    ;
in
{
  options.my = {
    user.name = mkOption {
      type = types.str;
      default = "justin"; # default primary user
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
    xmrig.enable = mkEnableOption "Enable XMRig mining service";
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
    opensnitch.enable = mkEnableOption "Enable OpenSnitch application firewall";
    signal-desktop.enable = mkEnableOption "Enable Signal Desktop messaging app";
    kav.enable = mkEnableOption "Enable kav kernel antivirus";
    devtools.enable = mkEnableOption "Enable development tools";
    zoom-us.enable = mkEnableOption "Enable Zoom video conferencing";
  };

  imports = [
    ./common
    ./networking
    ./podman
    ./fonts-locale
    ./bluetooth
    ./steam
    ./plymouth
    ./common-kernel
    ./custom-kernel
    ./pipewire
    ./home-manager
    ./display-manager
    ./dolphin
    ./wine
    ./xmrig
    ./ollama
    ./protonup
    ./obs
    ./waybar
    ./neovim
    ./firefox
    ./thunderbird
    ./ark
    ./xdg-apps
    ./hyprland
    ./rofi
    ./desktops/hyprland-extra.nix
    ./bash
    ./dconf
    ./vscode
    ./kde
    ./desktops/kde-extra.nix
    ./nvidia
    ./smartcards
    ./dod-certs
    ./remmina
    ./freerdp
    ./gnupg
    ./kleopatra
    ./nwg-display
    ./libreoffice
    ./okular
    ./flatpak
    ./screen
    ./brightnessctl
    ./kwallet
    ./kitty
    ./udiskie
    ./stylix
    ./bluedevil
    ./wayvnc
    ./virt-manager
    ./xwayland
    ./pinpam
    ./print
    ./hyprlock
    ./discord
    ./calibre
    ./shattered-pixel-dungeon
    ./qflipper
    ./scx
    ./spotify
    ./opensnitch
    ./signal-desktop
    ./kav
    ./devtools
    ./zoom-us
  ];

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
      calibre.enable = lib.mkDefault true;
      shattered-pixel-dungeon.enable = lib.mkDefault true;
      qflipper.enable = lib.mkDefault false;
      scx.enable = lib.mkDefault true;
      spotify.enable = lib.mkDefault true;
      opensnitch.enable = lib.mkDefault false;
      devtools.enable = lib.mkDefault false;
      zoom-us.enable = lib.mkDefault true;

      # Enable Rofi automatically when Hyprland is enabled.
      rofi.enable = lib.mkDefault config.my.hyprland.enable;

      # Derived values (not options): convenience for other modules.
      user.homeDir = "/home/${config.my.user.name}";
      # Leave these OFF by default (explicit opt-in):
      # hyprland, kde (desktop environments)
      # nvidia (GPU driver)
      # displayManager (only meaningful with Hyprland)
      # waybar (only meaningful with Hyprland; host can enable alongside hyprland)
      # xmrig (resource intensive)
      # ollama (large download / GPU intensive)
      # obs (often GPU-specific / optional)
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
