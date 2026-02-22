{ inputs, ... }:
{
  flake.nixosConfigurations.halloweentown = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../../hosts/halloweentown/configuration.nix
    ];
    specialArgs = { inherit inputs; };
  };
}
