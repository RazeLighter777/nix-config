{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.my.pinpam;
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
      enableMasterKeySubstitution = true;
      substituteMasterKeyAuth.hyprlock = {
        enable = true;
        rewriteSufficientRules = [
          "unix"
        ];
      };
      pinPolicy = {
        minLength = 4;
        maxLength = 6;
        maxAttempts = 5;
      };
    };
  };
}
