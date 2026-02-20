{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    pinpam = {
      url = "github:razelighter777/pinpam";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kav = {
      url = "git+ssh://git@gitlab.com/kav7205302/kav-client.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      stylix,
      pinpam,
      sops-nix,
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
          modules = [
            ./hosts/zenbox/configuration.nix
            sops-nix.nixosModules.sops
            inputs.kav.nixosModules.default
          ];
          specialArgs = { inherit inputs; };
        };
        suesslenovo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/suesslenovo/configuration.nix
            sops-nix.nixosModules.sops
          ];
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
