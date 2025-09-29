{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.my.protonup.enable {
    environment.systemPackages = [ pkgs.protonup-ng ];
  };
}
