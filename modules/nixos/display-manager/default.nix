{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.displayManager.enable {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    security.pam.services = {
      sddm-autologin.text = lib.mkForce ''
        auth     requisite pam_nologin.so
        auth     optional  ${config.security.pinpam.package}/lib/security/libpinpam_master_key.so
        auth     required  pam_succeed_if.so uid >= ${toString config.services.displayManager.sddm.autoLogin.minimumUid} quiet
        ${lib.optionalString config.my.kwallet.enable "auth     optional  ${pkgs.kdePackages.kwallet-pam}/lib/security/pam_kwallet5.so kdehome=.local/share"}
        auth     required  pam_permit.so

        account  include   sddm

        password include   sddm

        ${lib.optionalString config.my.kwallet.enable "session  optional  ${pkgs.kdePackages.kwallet-pam}/lib/security/pam_kwallet5.so auto_start kdehome=.local/share"}
        session  include   sddm
      '';
    };

    services.displayManager.autoLogin = {
      enable = true;
      user = config.my.user.name;
    };

    services.displayManager.defaultSession = "hyprland-uwsm";

    programs.uwsm.enable = true;
    programs.uwsm.package = pkgs.uwsm;
    programs.uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/start-hyprland";
    };
    services.xserver.desktopManager.runXdgAutostartIfNone = true;

  };
}
