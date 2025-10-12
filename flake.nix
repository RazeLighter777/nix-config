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
    {
      self,
      nixpkgs,
      nur,
      ...
    }:
    let
      # Import the NUR package set into `nurPkgs`
      nurPkgs = import nur { inherit nixpkgs; };
    in
    {
      nixpkgs.config.packageOverrides = pkgs: {
        # Add nur as part of the pkgs set so it will be accessible as pkgs.nur
        nur = nurPkgs;
      };

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
