{ lib, config, inputs, pkgs, ... }:
let
  cfg = config.my.stylix;
in
{
  # Import Stylix module unconditionally; control activation via cfg.enable
  imports = [ inputs.stylix.nixosModules.stylix ];

  config = {
    
    # Activate stylix only when my.stylix.enable is true
    stylix.enable = lib.mkDefault cfg.enable;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/summerfruit-dark.yaml";
    stylix.opacity = {
      terminal = 0.7;
      desktop = 0.9;
    };
    stylix.cursor = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
        size = 24;
    };
    stylix.icons = {
      package = pkgs.tela-icon-theme;
      light = "Tela-Light";
      dark = "Tela-Dark";
      enable = true;
    };
    stylix.polarity = "dark"; # "light" | "dark" | "auto"
  };
}