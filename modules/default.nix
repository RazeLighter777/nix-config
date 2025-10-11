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
    nemo.enable = mkEnableOption "Enable Nemo file manager";
    nemoDesktop.enable = mkEnableOption "Register Nemo desktop/xgd entries";
    wine.enable = mkEnableOption "Enable Wine packages";
    xmrig.enable = mkEnableOption "Enable XMRig mining service";
    ollama.enable = mkEnableOption "Enable Ollama service (CUDA)";
    protonup.enable = mkEnableOption "Enable protonup-ng tool";
    obs.enable = mkEnableOption "Enable OBS Studio with plugins";
    waybar.enable = mkEnableOption "Enable Waybar configuration";
    neovim.enable = mkEnableOption "Enable Neovim configuration";
    firefox.enable = mkEnableOption "Enable Firefox configuration";
    hyprland.enable = mkEnableOption "Enable Hyprland home-manager configuration";
    bash.enable = mkEnableOption "Enable Bash configuration";
    dconf.enable = mkEnableOption "Enable dconf settings";
    vscode.enable = mkEnableOption "Enable VSCode configuration";
    kde.enable = mkEnableOption "Enable KDE Plasma desktop";
    nvidia.enable = mkEnableOption "Enable NVIDIA drivers and related settings";
    remmina.enable = mkEnableOption "Enable Remmina remote desktop client";
    freerdp.enable = mkEnableOption "Enable FreeRDP client";
    gnupg.enable = mkEnableOption "Enable gpg agent";
    kanshi.enable = mkEnableOption "Enable kanshi";
    libreoffice.enable = mkEnableOption "Enable libreoffice";
    flatpak.enable = mkEnableOption "Enable flatpaks";
  };

  imports = [
    ./common
    ./networking
    ./docker
    ./fonts-locale
    ./bluetooth
    ./steam
    ./plymouth
    ./common-kernel
    ./pipewire
    ./home-manager
    ./display-manager
    ./nemo
    ./nemo-desktop
    ./wine
    ./xmrig
    ./ollama
    ./protonup
    ./obs
    ./waybar
    ./neovim
    ./firefox
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
    ./kanshi
    ./libreoffice
    ./flatpak
  ];

  config = {
    my = {
      # Defaults: most user applications enabled unless explicitly disabled in a host.
      homeManager.enable = lib.mkDefault true;
      nemo.enable = lib.mkDefault true;
      nemoDesktop.enable = lib.mkDefault true;
      wine.enable = lib.mkDefault true;
      protonup.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
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
      kanshi.enable = lib.mkDefault true;
      libreoffice.enable = lib.mkDefault true;
      flatpak.enable = lib.mkDefault true;
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
