{
  config,
  pkgs,
  lib,
  ...
}:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    sha256 = "0q83c34qf6wx5fsjhnwl6b774a0gz0y8qvamlysz1hsil42k18qq"; # keep existing
  };
  unstable = pkgs.unstable or pkgs; # fallback if overlay not present
in
{
  imports = [ (import "${home-manager}/nixos") ];

  config = lib.mkIf config.my.homeManager.enable {
    home-manager.verbose = true;
    nixpkgs.config.allowUnfree = true;
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
          pkgs.httpie
        ];
        nixpkgs.config.allowUnfree = true;
        home.stateVersion = "25.05";
        home.enableNixpkgsReleaseCheck = false;
      };
    home-manager.extraSpecialArgs = { inherit unstable; };
  };
}
