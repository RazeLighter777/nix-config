{
  description = "A simple NixOS flake";
  inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      hostName = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ "./configuration.nix" "arion.nixosModules.arion" ];
      };
    };
  };
}
