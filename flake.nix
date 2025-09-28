{
  description = "A simple NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, ... }:
    {
      nixosConfigurations = {
        hostName = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./modules/configuration.nix ];
        };
      };
    };
}
