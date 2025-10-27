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
    cliphist
    wl-clip-persist
    swayimg
  ];
  security.pam.services.hyprlock = {};
  programs.hyprland.withUWSM = true;
}
