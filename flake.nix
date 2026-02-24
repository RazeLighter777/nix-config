{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
      url = "github:razelighter777/pinpam/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # Provides `configurations.nixos` option + nixosConfigurations wiring.
        ./modules/nixos.nix
        # Registers all NixOS feature modules as flake.nixosModules.*.
        ./modules/nixos/default.nix
        # Host declarations — each sets configurations.nixos.<name>.module.
        ./modules/hosts/zenbox.nix
        ./modules/hosts/suesslenovo.nix
        ./modules/hosts/halloweentown.nix
      ];
      systems = [ "x86_64-linux" ];
    };
}
