# Top-level flake-parts module that provides the `configurations.nixos` option.
# Each host module sets `configurations.nixos.<name>.module` with a deferredModule
# value composed from `config.flake.nixosModules.*`.  The config below wires those
# entries into the standard `flake.nixosConfigurations` flake output.
{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The NixOS module that defines this host's configuration.";
        };
      }
    );
    default = { };
    description = "NixOS host configurations, assembled from `flake.nixosModules.*`.";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _name: { module }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ module ];
    }
  ) config.configurations.nixos;
}
