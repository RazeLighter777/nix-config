# Flake-parts entry point for all NixOS feature modules.
# Each feature is registered as a separate `flake.nixosModules.<name>` value so
# host modules can compose them via `config.flake.nixosModules`.
# `flake.nixosModules.all` bundles every feature for convenience — host modules
# simply import it alongside their hardware configuration.
{ ... }:
{
  flake.nixosModules = {
    # Base: shared options (my.*) and default enable values.
    options = import ./options.nix;

    # Feature modules — one per file, imported as NixOS deferredModules.
    common = import ./common/default.nix;
    networking = import ./networking/default.nix;
    podman = import ./podman/default.nix;
    fonts-locale = import ./fonts-locale/default.nix;
    bluetooth = import ./bluetooth/default.nix;
    steam = import ./steam/default.nix;
    plymouth = import ./plymouth/default.nix;
    common-kernel = import ./common-kernel/default.nix;
    custom-kernel = import ./custom-kernel/default.nix;
    pipewire = import ./pipewire/default.nix;
    power-profiles-daemon = import ./power-profiles-daemon/default.nix;
    home-manager = import ./home-manager/default.nix;
    display-manager = import ./display-manager/default.nix;
    dolphin = import ./dolphin/default.nix;
    wine = import ./wine/default.nix;
    ollama = import ./ollama/default.nix;
    protonup = import ./protonup/default.nix;
    obs = import ./obs/default.nix;
    waybar = import ./waybar/default.nix;
    neovim = import ./neovim/default.nix;
    firefox = import ./firefox/default.nix;
    thunderbird = import ./thunderbird/default.nix;
    ark = import ./ark/default.nix;
    xdg-apps = import ./xdg-apps/default.nix;
    hyprland = import ./hyprland/default.nix;
    rofi = import ./rofi/default.nix;
    mako = import ./mako/default.nix;
    hyprland-extra = import ./desktops/hyprland-extra.nix;
    bash = import ./bash/default.nix;
    dconf = import ./dconf/default.nix;
    vscode = import ./vscode/default.nix;
    kde = import ./kde/default.nix;
    kde-extra = import ./desktops/kde-extra.nix;
    nvidia = import ./nvidia/default.nix;
    smartcards = import ./smartcards/default.nix;
    dod-certs = import ./dod-certs/default.nix;
    remmina = import ./remmina/default.nix;
    freerdp = import ./freerdp/default.nix;
    gnupg = import ./gnupg/default.nix;
    kleopatra = import ./kleopatra/default.nix;
    nwg-display = import ./nwg-display/default.nix;
    libreoffice = import ./libreoffice/default.nix;
    okular = import ./okular/default.nix;
    flatpak = import ./flatpak/default.nix;
    screen = import ./screen/default.nix;
    brightnessctl = import ./brightnessctl/default.nix;
    kwallet = import ./kwallet/default.nix;
    kitty = import ./kitty/default.nix;
    udiskie = import ./udiskie/default.nix;
    stylix = import ./stylix/default.nix;
    bluedevil = import ./bluedevil/default.nix;
    wayvnc = import ./wayvnc/default.nix;
    virt-manager = import ./virt-manager/default.nix;
    xwayland = import ./xwayland/default.nix;
    pinpam = import ./pinpam/default.nix;
    print = import ./print/default.nix;
    hyprlock = import ./hyprlock/default.nix;
    discord = import ./discord/default.nix;
    calibre = import ./calibre/default.nix;
    shattered-pixel-dungeon = import ./shattered-pixel-dungeon/default.nix;
    qflipper = import ./qflipper/default.nix;
    scx = import ./scx/default.nix;
    spotify = import ./spotify/default.nix;
    signal-desktop = import ./signal-desktop/default.nix;
    kav = import ./kav/default.nix;
    devtools = import ./devtools/default.nix;
    zoom-us = import ./zoom-us/default.nix;
    bitwarden = import ./bitwarden/default.nix;
    ssh-agent = import ./ssh-agent/default.nix;
    systemd-sandboxing = import ./systemd-sandboxing/default.nix;
    ghidra-bin = import ./ghidra-bin/default.nix;
    okteta = import ./okteta/default.nix;
  };
}
