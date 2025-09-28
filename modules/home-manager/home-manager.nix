{
  config,
  pkgs,
  lib,
  ...
}:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-master.tar.gz";
    sha256 = "0q3lv288xlzxczh6lc5lcw0zj9qskvjw3pzsrgvdh8rl8ibyq75s";
  };
  unstable = pkgs.unstable;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  
  home-manager.verbose = true;
  home-manager.users.justin =
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
      # User-specific settings (packages, stateVersion, etc.)
      home.username = "justin";
      home.packages = [
        pkgs.atool
        pkgs.httpie
      ];
      nixpkgs.config = {
        allowUnfree = true;
      };
      # Add any other user-specific settings here
    };
  home-manager.extraSpecialArgs = { inherit unstable; };
}
