{ lib, config, inputs, pkgs, ... }:
let
  cfg = config.my.nautilus;
in
{
  config = lib.mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [
      nautilus
    ];
  };
}