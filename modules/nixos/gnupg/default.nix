{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.${config.my.user.name} = {
    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableScDaemon = true;
      enableSshSupport = true;
    };
    systemd.user.services = {
      gpg-agent.Service = config.my.systemd-sandboxing.user-desktop;
      gpg-agent-ssh.Service = config.my.systemd-sandboxing.user-desktop;
      gpg-agent-extra.Service = config.my.systemd-sandboxing.user-desktop;
      gpg-agent-browser.Service = config.my.systemd-sandboxing.user-desktop;
    };
  };
  security.pam.services = lib.mkMerge [
    (lib.mkIf config.my.hyprland.enable {
      sddm-autologin.gnupg.enable = true;
    })
    (lib.mkIf config.services.displayManager.sddm.enable {
      sddm-autologin.gnupg.enable = true;
    })
    {
      login.gnupg.enable = true;
    }
  ];

}
