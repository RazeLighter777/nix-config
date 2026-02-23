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
  ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.overlays = lib.mkAfter [
    (final: _prev: {
      system = final.stdenv.hostPlatform.system;
    })
  ];
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  programs.direnv.enable = lib.mkDefault true;
}
