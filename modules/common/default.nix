{
  config,
  pkgs,
  lib,
  ...
}:
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
    nixfmt-rfc-style
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
  ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = lib.mkAfter [
      "https://nix.prizrak.me"
    ];
    trusted-public-keys = lib.mkAfter [
      "prizrak.me:Hk9hSoa/uKOc4cEu8Tu7a4XRkkG08HBs8fQC6nhcuds="
    ];
    builders-use-substitutes = true;
  };
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  programs.direnv.enable = lib.mkDefault true;
}
