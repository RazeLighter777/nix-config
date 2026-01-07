{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.xwayland.enable {
    # Enable xwayland for both KDE and Hyprland
    programs.xwayland.enable = true;
    
    # Additional xwayland-related packages
    environment.systemPackages = with pkgs; [
      xwayland
    ];
  };
}
