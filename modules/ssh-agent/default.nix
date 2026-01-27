{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.ssh-agent.enable {
    home-manager.users.${config.my.user.name} = {
      home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
      systemd.user.services.ssh-agent = {
        Unit = {
          Description = "SSH Agent";
        };
        Service = {
          ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
