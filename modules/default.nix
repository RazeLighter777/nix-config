{ config, lib, ... }:

let
  cfg = config.my;
  inherit (lib) mkEnableOption mkIf optional any mkOption types;
  homeMgrNeeded = cfg.homeManager.enable || any (x: x) [
    cfg.waybar.enable
    cfg.neovim.enable
    cfg.firefox.enable
    cfg.hyprland.enable
    cfg.bash.enable
    cfg.dconf.enable
    cfg.vscode.enable
    cfg.nemoDesktop.enable
  ];
in {
  options.my = {
    user.name = mkOption {
      type = types.str;
      default = "justin"; # default primary user
      description = "Primary (single) user account name used by home-manager modules.";
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
    fontsLocale.enable = mkEnableOption "Enable shared fonts + extended locale settings";
    bluetooth.enable = mkEnableOption "Enable Bluetooth stack and utilities";
    steam.enable = mkEnableOption "Enable Steam gaming platform";
    plymouth.enable = mkEnableOption "Enable Plymouth splash";
    commonKernel.enable = mkEnableOption "Enable shared kernel configuration";
  };

  imports = [ ./common ./networking ./docker ./fonts-locale ./bluetooth ./steam ./plymouth ./common-kernel ]
    ++ (optional homeMgrNeeded ./home-manager)
    ++ (optional cfg.displayManager.enable ./display-manager)
    ++ (optional cfg.nemo.enable ./nemo)
    ++ (optional cfg.nemoDesktop.enable ./nemo-desktop)
    ++ (optional cfg.wine.enable ./wine)
    ++ (optional cfg.xmrig.enable ./xmrig)
    ++ (optional cfg.ollama.enable ./ollama)
    ++ (optional cfg.protonup.enable ./protonup)
    ++ (optional cfg.obs.enable ./obs)
    ++ (optional cfg.waybar.enable ./waybar)
    ++ (optional cfg.neovim.enable ./neovim)
    ++ (optional cfg.firefox.enable ./firefox)
  ++ (optional cfg.hyprland.enable ./hyprland)
  ++ (optional cfg.hyprland.enable ./desktops/hyprland-extra.nix)
    ++ (optional cfg.bash.enable ./bash)
    ++ (optional cfg.dconf.enable ./dconf)
    ++ (optional cfg.vscode.enable ./vscode)
    ++ (optional cfg.kde.enable ./kde)
  ++ (optional cfg.kde.enable ./desktops/kde-extra.nix)
    ++ (optional cfg.nvidia.enable ./nvidia);

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
        assertion = !(cfg.hyprland.enable && cfg.kde.enable);
        message = "Cannot enable both Hyprland and KDE simultaneously.";
      }
      {
        assertion = !(cfg.displayManager.enable && cfg.kde.enable);
        message = "KDE (Plasma) uses SDDM; disable the greetd displayManager module.";
      }
    ];
  };
}
