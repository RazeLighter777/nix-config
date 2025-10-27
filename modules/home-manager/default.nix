{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    sha256 = "031z0xgrh3w81w4cz0pz58aknri3by7fgxv8wi17hx2hvp42z3lx";
  };
  unstable = pkgs.unstable or pkgs; # fallback if overlay not present
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  config = lib.mkIf config.my.homeManager.enable {
    home-manager.verbose = true;
    nixpkgs.config.allowUnfree = true;
    home-manager.extraSpecialArgs = { inherit inputs; };
    home-manager.users.${config.my.user.name} =
      { pkgs, ... }:
      {
        stylix.autoEnable = false;
        stylix.targets.opencode.enable = false;
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
        home.stateVersion = "25.05";
        home.enableNixpkgsReleaseCheck = false;
      };
    home-manager.extraSpecialArgs = { inherit unstable; };
  };
}
