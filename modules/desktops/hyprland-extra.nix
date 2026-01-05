{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hyprcursor
    swww
    uwsm
    waybar
    wayvnc
    pavucontrol
    hyprpicker
    wl-clipboard
    cliphist
    wl-clip-persist
    swayimg
  ];
  security.pam.services.hyprlock = { };
  programs.hyprland.withUWSM = true;
}
