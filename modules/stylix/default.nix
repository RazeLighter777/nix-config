{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.my.stylix;
  user = config.my.user.name;
in
{
  # Import Stylix module unconditionally; control activation via cfg.enable
  imports = [ inputs.stylix.nixosModules.stylix ];

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      stylix.targets.kde.enable = cfg.enable;
    };
    # Activate stylix only when my.stylix.enable is true
    stylix.enable = lib.mkDefault cfg.enable;
    stylix.enableReleaseChecks = false;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";
    stylix.opacity = {
      terminal = 0.7;
      desktop = 0.7;
    };
    stylix.cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
    };
    stylix.icons = {
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
      enable = true;
    };
    stylix.polarity = "dark"; # "light" | "dark" | "auto"
  };
}
