{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    hyprlock
    hyprcursor
    hyprpaper
    uwsm
    waybar
    wayvnc
    networkmanagerapplet
    pavucontrol
    hyprnotify
  ];
  programs.hyprland.withUWSM = true;
}
