{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.${config.my.user.name}.services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableScDaemon = true;
    enableSshSupport = true;
  };
  security.pam.services = lib.mkMerge [
    (lib.mkIf config.my.hyprland.enable {
      hyprlock.gnupg.enable = true;
    })
    (lib.mkIf config.services.displayManager.sddm.enable {
      sddm.gnupg.enable = true;
    })
  ];

}
