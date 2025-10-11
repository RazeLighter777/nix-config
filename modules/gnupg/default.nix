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
}
