{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.kwallet.enable {
    environment.systemPackages = [
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwalletmanager
      pkgs.kdePackages.kwallet-pam
      pkgs.kdePackages.ksshaskpass
    ];
    home-manager.users.${config.my.user.name}.home.sessionVariables = {
      SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      SSH_ASKPASS_REQUIRE = "prefer";
    };
    security.pam.services = lib.mkMerge [
      (lib.mkIf config.my.hyprland.enable {
        hyprlock.kwallet.enable = true;
      })
      (lib.mkIf config.services.displayManager.sddm.enable {
        sddm.kwallet.enable = true;
      })
    ];
  };
}
