{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprlock
    hyprcursor
    hyprpaper
    uwsm
    waybar
    wayvnc
    networkmanagerapplet
    pavucontrol
    hyprpicker
    wl-clipboard
  ];
  programs.hyprland.withUWSM = true;
}
