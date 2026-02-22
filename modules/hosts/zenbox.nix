{ inputs, ... }:
{
  flake.nixosConfigurations.zenbox = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../../hosts/zenbox/configuration.nix
      inputs.sops-nix.nixosModules.sops
      inputs.kav.nixosModules.default
    ];
    specialArgs = { inherit inputs; };
  };
}
