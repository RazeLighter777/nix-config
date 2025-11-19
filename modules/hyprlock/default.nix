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
        ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
      };
    };
  };
}
