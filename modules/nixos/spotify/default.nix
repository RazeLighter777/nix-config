{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.spotify.enable {
    nixpkgs.config.allowUnfree = lib.mkDefault true;
    environment.systemPackages = [ pkgs.spotify ];
  };
}
