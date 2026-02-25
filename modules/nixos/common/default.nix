{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  stablePkgs = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  # Common baseline packages across all hosts (can be overridden/extended per host).
  environment.systemPackages = with pkgs; [
    vim
    wget
    ripgrep
    htop
    git
    gnumake
    openssl
    pkg-config
    kubectl
    fluxcd
    k9s
    nixfmt
    nfs-utils
    lsof
    unzip
    file
    jq
    nettools
    fastfetch
    tcpdump
    perf
    fzf
    python3
    nmap
    direnv
    gnupg
    pinentry-qt
    p7zip
    killall
    sops
    ssh-to-age
    emacs
    kdePackages.qtstyleplugin-kvantum
    kdePackages.kcmutils
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    stablePkgs.libsForQt5.kcmutils
  ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  programs.direnv.enable = lib.mkDefault true;
}
