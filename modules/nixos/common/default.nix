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
  systemd.services.nix-daemon.environment.OPENSSL_CONF = pkgs.writeText "no-mlkem.cnf" ''
    openssl_conf = default_conf
    [default_conf]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Groups = X25519:secp256r1:secp384r1:secp521r1:X448:ffdhe2048:ffdhe3072
  '';
  environment.systemPackages = with pkgs; [
    vim
    wget
    ripgrep
    htop
    gitFull
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
  environment.etc."polkit-1/rules.d/10-run0-auth-keep.rules".text = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.run" && subject.isInGroup("wheel")) {
            return polkit.Result.AUTH_KEEP;
        }
    });
  '';

  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  programs.direnv.enable = lib.mkDefault true;
}
