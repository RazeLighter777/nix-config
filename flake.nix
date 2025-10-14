{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dolphin-overlay = {
      url = "github:rumboon/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      stylix,
      dolphin-overlay,
      ...
    }@inputs:
    let
      # Import nur, passing nixpkgs to it
      nurPkgs = import nur { inherit nixpkgs; };
    in
    {
      nixpkgs.config.packageOverrides = pkgs: {
        # Make nur available under pkgs.nur
        nur = nurPkgs;
      };

      nixosConfigurations = {
        zenbox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/zenbox/configuration.nix ];
          specialArgs = { inherit inputs; };
        };
        suesslenovo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/suesslenovo/configuration.nix ];
          specialArgs = { inherit inputs; };
        };
        halloweentown = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/halloweentown/configuration.nix ];
        };
      };
    };
}
