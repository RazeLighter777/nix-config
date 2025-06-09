{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball { url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"; sha256 = "";};
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  users.users.eve.isNormalUser = true;
  home-manager.users.eve = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
