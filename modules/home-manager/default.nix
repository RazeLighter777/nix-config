{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  unstable = pkgs.unstable or pkgs; # fallback if overlay not present
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = lib.mkIf config.my.homeManager.enable {
    home-manager.verbose = true;
    nixpkgs.config.allowUnfree = true;
    home-manager.extraSpecialArgs = { inherit inputs unstable; };
    home-manager.users.${config.my.user.name} =
      { pkgs, ... }:
      {
        imports = [
          "${
            fetchTarball {
              url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
              sha256 = "1rdn70jrg5mxmkkrpy2xk8lydmlc707sk0zb35426v1yxxka10by";
            }
          }/modules/vscode-server/home.nix"
        ];
        home.username = config.my.user.name;
        home.packages = [
          pkgs.atool
          pkgs.dconf
          pkgs.httpie
        ];
        nixpkgs.config.allowUnfree = true;
        home.stateVersion = "25.11";
        home.enableNixpkgsReleaseCheck = false;
      };
  };
}
