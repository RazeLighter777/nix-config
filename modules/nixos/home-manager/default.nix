{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  unstable = pkgs.unstable or pkgs; # fallback if overlay not present
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = lib.mkMerge [
    {
      home-manager.backupFileExtension = "hm-bak";
    }
    (lib.mkIf config.my.homeManager.enable {
      home-manager.verbose = true;
      nixpkgs.config.allowUnfree = true;
      home-manager.extraSpecialArgs = { inherit inputs unstable; };
      home-manager.users.${config.my.user.name} =
        { pkgs, ... }:
        {
          home.username = config.my.user.name;
          home.packages = [
            pkgs.atool
            pkgs.dconf
            pkgs.httpie
          ];
          nixpkgs.config.allowUnfree = true;
          home.stateVersion = "26.05";
          home.enableNixpkgsReleaseCheck = false;
        };
    })
  ];
}
