{ config, lib, pkgs, ... }:
let cfg = config.my.smartcards; in {
  options.my.smartcards.enable = lib.mkEnableOption "Enable smart card support (PC/SC daemon)";
  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;
    services.pcscd.plugins = [ pkgs.acsccid ];
    environment.systemPackages = [ pkgs.pcsc-tools pkgs.opensc pkgs.nss_latest.tools pkgs.gnupg-pkcs11-scd ];
    security.pam.p11.enable = true;

    programs.gnupg.agent = {
      enable = true;
      settings = {
        providers = "opensc";
        provider-opensc-library = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      };
    };
  };
}