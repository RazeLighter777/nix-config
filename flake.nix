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
        zenbox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/zenbox/configuration.nix ];
        };
        suesslenovo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/suesslenovo/configuration.nix ];
        };
        halloweentown = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/halloweentown/configuration.nix ];
        };
      };
    };
}
