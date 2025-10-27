{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.my.pinpam;
in
{
  # Import Stylix module unconditionally; control activation via cfg.enable
  imports = [ inputs.pinpam.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    # Pinpam-specific configurations can go here
    security.pinpam = {
      enable = true;
      enableTpmAccess = true;
      enableSudoPin = true;
      enableHyprlockPin=true;
      pinPolicy = {
        minLength = 4;
	maxLength = 6;
	maxAttempts = 5;
      };
    };
  };
}
