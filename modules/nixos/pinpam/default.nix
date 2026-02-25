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
    security.pinpam = {
      enable = true;

      tpm.enableAccess = true;

      auth = {
        enable = true;
        services = [
          "sudo"
          "hyprlock"
          "system-auth"
          "polkit-1"
          "login"
          "sddm-autologin"
        ];
      };

      masterKey = {
        enable = true;
        services.sddm-autologin = {
          enable = true;
          successRules = [
            "nologin"
          ];
          postAuthRules = [
            "kwallet"
            "gnupg"
          ];
        };
      };

      pin.policy = {
        minLength = 4;
        maxLength = 6;
        maxAttempts = 5;
      };
    };
  };
}
