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
    zathura
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
    valgrind
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  programs.direnv.enable = lib.mkDefault true;
}
