{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.gnupg = {
    agent.enable = true;
    agent.enableBrowserSocket = true;
    agent.enableSSHSupport = true;
  };
}
