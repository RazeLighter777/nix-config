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
      pinPolicy = {
        maxAttempts = 5;
      };
    };
  };
}
