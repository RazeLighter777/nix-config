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
  imports = [ inputs.pinpam.nixosModules.pinpam ];

  config = lib.mkIf cfg.enable {
    # Pinpam-specific configurations can go here
    security.pinpam = {
      enable = true;
      enableTpmAccess = true;
      settings = {
        maxAttempts = 5;
        lockoutDuration = 300;
      };
    };
  };
}
