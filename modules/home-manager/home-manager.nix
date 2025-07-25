{
  config,
  pkgs,
  lib,
  ...
}:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "12246mk1xf1bmak1n36yfnr4b0vpcwlp6q66dgvz8ip8p27pfcw2";
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
      home.packages = [
        pkgs.atool
        pkgs.httpie
      ];
      home.stateVersion = "25.05";
      # Add any other user-specific settings here
    };
}
