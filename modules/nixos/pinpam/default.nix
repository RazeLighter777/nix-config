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
        # New option (preferred)
        rewriteSuccessJumps = {
          unix = 1;
          pinpam = 5;
        };

        # Optional if you want explicit placement (defaults already 13000/13010)
        denyOrder = 13000;
        masterKeyOrder = 13010;
      };
      pinPolicy = {
        minLength = 4;
        maxLength = 6;
        maxAttempts = 5;
      };
    };
  };
}
