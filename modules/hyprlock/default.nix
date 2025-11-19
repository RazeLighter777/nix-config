{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.hyprland.enable {
    home-manager.users.${config.my.user.name} = {
      home.file = {
        ".config/hypr/hyprland.conf".source = ./hyprlock.conf;
      };
    };
  };
}
