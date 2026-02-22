{ inputs, ... }:
{
  flake.nixosConfigurations.suesslenovo = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../../hosts/suesslenovo/configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];
    specialArgs = { inherit inputs; };
  };
}
