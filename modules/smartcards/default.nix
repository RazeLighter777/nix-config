{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.smartcards;
in
{
  options.my.smartcards.enable = lib.mkEnableOption "Enable smart card support (PC/SC daemon)";
  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;
    services.pcscd.plugins = [ pkgs.acsccid ];
    environment.systemPackages = [
      pkgs.pcsc-tools
      pkgs.opensc
      pkgs.nss_latest.tools
      pkgs.gnupg-pkcs11-scd
      pkgs.ccid
    ];

    programs.gnupg.agent = {
      enable = true;
    };
    environment.etc."opensc.conf".text = ''
      # OpenSC configuration file
      enable_pinpad = false
      card_drivers = cac
      force_card_driver = cac
    '';
  };
}
