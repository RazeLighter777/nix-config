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
    displayManager.enable = mkEnableOption "Enable greetd / tuigreet display manager for Hyprland";
    nautilus.enable = mkEnableOption "Enable nautilus file manager";
    wine.enable = mkEnableOption "Enable Wine packages";
    xmrig.enable = mkEnableOption "Enable XMRig mining service";
    ollama.enable = mkEnableOption "Enable Ollama service (CUDA)";
    protonup.enable = mkEnableOption "Enable protonup-ng tool";
    obs.enable = mkEnableOption "Enable OBS Studio with plugins";
    waybar.enable = mkEnableOption "Enable Waybar configuration";
    neovim.enable = mkEnableOption "Enable Neovim configuration";
    firefox.enable = mkEnableOption "Enable Firefox configuration";
    thunderbird.enable = mkEnableOption "Enable Thunderbird configuration";
    hyprland.enable = mkEnableOption "Enable Hyprland home-manager configuration";
    bash.enable = mkEnableOption "Enable Bash configuration";
    dconf.enable = mkEnableOption "Enable dconf settings";
    vscode.enable = mkEnableOption "Enable VSCode configuration";
    kde.enable = mkEnableOption "Enable KDE Plasma desktop";
    nvidia.enable = mkEnableOption "Enable NVIDIA drivers and related settings";
    remmina.enable = mkEnableOption "Enable Remmina remote desktop client";
    freerdp.enable = mkEnableOption "Enable FreeRDP client";
    gnupg.enable = mkEnableOption "Enable gpg agent";
    nwg-display.enable = mkEnableOption "Enable nwg-display";
    libreoffice.enable = mkEnableOption "Enable libreoffice";
    flatpak.enable = mkEnableOption "Enable flatpaks";
    screen.enable = mkEnableOption "Enable screen";
    brightnessctl.enable = mkEnableOption "Enable brightness";
    gnome-keyring.enable = mkEnableOption "Gnome keyring";
    battery.enable = mkEnableOption "Battery support";
    kitty.enable = mkEnableOption "Kitty terminal";
    udiskie.enable = mkEnableOption "Udiskie";
    stylix.enable = mkEnableOption "Enable Stylix tiling window manager";
    xdg-apps.enable = mkEnableOption "Enable custom XDG MIME applications";
    blueberry.enable = mkEnableOption "Enable Blueberry Bluetooth configuration";
    wayvnc.enable = mkEnableOption "Enable WayVNC server for Hyprland";
    pinpam.enable = mkEnableOption "Enable PIN and PAM integration";
    discord.enable = mkEnableOption "Enable Discord configuration";
    customKernel.enable = mkEnableOption "Enable custom linux-landlock-no-inherit kernel";
    calibre.enable = mkEnableOption "Enable Calibre eBook manager";
    sunshine.enable = mkEnableOption "Enable Sunshine game streaming server";
    moonlight.enable = mkEnableOption "Enable Moonlight game streaming client";
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
    ./nautilus
    ./wine
    ./xmrig
    ./ollama
    ./protonup
    ./obs
    ./waybar
    ./neovim
    ./firefox
    ./thunderbird
    ./xdg-apps
    ./hyprland
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
    ./nwg-display
    ./libreoffice
    ./flatpak
    ./screen
    ./brightnessctl
    ./gnome-keyring
    ./seahorse
    ./kitty
    ./udiskie
    ./stylix
    ./blueberry
    ./wayvnc
    ./pinpam
    ./print
    ./hyprlock
    ./discord
    ./calibre
    ./sunshine
    ./moonlight
    ./pcmanfm
  ];

  config = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    my = {
      # Defaults: most user applications enabled unless explicitly disabled in a host.
      homeManager.enable = lib.mkDefault true;
      nautilus.enable = lib.mkDefault true;
      wine.enable = lib.mkDefault true;
      protonup.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
      thunderbird.enable = lib.mkDefault true;
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
      nwg-display.enable = lib.mkDefault true;
      libreoffice.enable = lib.mkDefault true;
      flatpak.enable = lib.mkDefault true;
      screen.enable = lib.mkDefault true;
      brightnessctl.enable = lib.mkDefault false;
      gnome-keyring.enable = lib.mkDefault false;
      battery.enable = lib.mkDefault false;
      kitty.enable = lib.mkDefault true;
      udiskie.enable = lib.mkDefault true;
      stylix.enable = lib.mkDefault false;
      xdg-apps.enable = lib.mkDefault true;
      blueberry.enable = lib.mkDefault false;
      wayvnc.enable = lib.mkDefault false;
      pinpam.enable = lib.mkDefault false;
      print.enable = lib.mkDefault true;
      discord.enable = lib.mkDefault true;
      customKernel.enable = lib.mkDefault false;
      calibre.enable = lib.mkDefault true;
      sunshine.enable = lib.mkDefault false;
      moonlight.enable = lib.mkDefault false;
      pcmanfm.enable = lib.mkDefault false;
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
        message = "KDE (Plasma) uses SDDM; disable the greetd displayManager module.";
      }
    ];
  };
}
