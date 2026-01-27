{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.my.rofi;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = with pkgs; [
        rofi
        rofi-power-menu
        rofimoji
      ];

      home.file.".config/rofi/rofi-system-menu.sh" = {
        source = ./rofi-system-menu.sh;
        executable = true;
      };

      programs.rofi = {
        enable = true;

        extraConfig = {
          show-icons = true;
          drun-display-format = "{name}";
          modi = "drun,run,window,emoji:rofimoji";
        };
      };
    };
  };
}
