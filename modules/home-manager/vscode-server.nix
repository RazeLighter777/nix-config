{ pkgs, ... }:
{
  home-manager.users.justin.services.vscode-server.enable = true;
  home-manager.users.justin.imports = [
    (fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "1l77kybmghws3y834b1agb69vs6h4l746ga5xccvz4p1y8wc67h7";
    } + "/modules/vscode-server/home.nix")
  ];
}
