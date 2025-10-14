{ lib, config, inputs, pkgs, ... }:
let
  cfg = config.my.nautilus
{
  config = lib.mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [
      gnome3.nautilusExtensions
      gnome3.nautilus
    ];
  };
}