{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.my.stylix;
in
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
  };

  outputs = { self, nixpkgs, dolphin-overlay, ... }: {
    nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [ dolphin-overlay.overlays.default ];
        }
      ];
    };
  };
}