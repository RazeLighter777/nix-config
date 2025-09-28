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
            sha256 = "1l77kybmghws3y834b1agb69vs6h4l746ga5xccvz4p1y8wc67h7";
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
      home.stateVersion = "25.05";
      # Add any other user-specific settings here
    };
}
