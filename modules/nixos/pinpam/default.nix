{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.my.pinpam;
  pinpamPkg = inputs.pinpam.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [ inputs.pinpam.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    # Pinpam-specific configurations can go here
    security.pinpam = {
      enable = true;
      enableSudoPin = true;
      enableTpmAccess = true;
      enableHyprlockPin = true;
      enableSystemAuthPin = true;
      enablePolkitPin = true;
      pinPolicy = {
        minLength = 4;
        maxLength = 6;
        maxAttempts = 5;
      };
    };
    security.pam.services.polkit-1.rules.auth.pinpam = {
      control = "sufficient";
      modulePath = "${pinpamPkg}/lib/security/libpinpam.so";
      order = config.security.pam.services.polkit-1.rules.auth.unix.order - 10;
    };
  };
}
