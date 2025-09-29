{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.my.reminna.enable {
    environment.systemPackages = [ pkgs.remmina ];
  };
}
