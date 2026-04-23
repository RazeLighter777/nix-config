{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.bitwarden.enable {
    nixpkgs.config.allowUnfree = lib.mkDefault true;
    environment.systemPackages = [
    ];
  };
}
