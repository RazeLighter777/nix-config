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
  imports = [ inputs.pinpam.nixosModules.default ];
  config = lib.mkIf cfg.enable {
    # Pinpam-specific configurations can go here
    security.pinpam = {
      enable = true;
      enableSudoPin = true;
      enableTpmAccess = true;
      enableHyprlockPin = true;
      enableSystemAuthPin = true;
      pinPolicy = {
        minLength = 4;
	maxLength = 6;
	maxAttempts = 5;
      };
    };
  };
}
