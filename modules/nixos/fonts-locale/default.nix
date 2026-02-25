{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.fontsLocale;
in
{
  options.my.fontsLocale.enable = lib.mkEnableOption "Enable shared fonts and locale extra settings";
  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      dejavu_fonts
      emacs-all-the-icons-fonts
      fira-code
      nerd-fonts.fira-code
      font-awesome
      noto-fonts
      nerd-fonts.noto
      noto-fonts-color-emoji
    ];
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
