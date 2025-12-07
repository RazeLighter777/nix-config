{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.my.moonlight.enable {
    environment.systemPackages = [ pkgs.moonlight-qt ];
  };
}
