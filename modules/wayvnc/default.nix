{
  lib,
  pkgs,
  config,
}:
{
  config = lib.mkIf config.my.wayvnc.enable {
    home-manager.users.${config.my.user.name} = {
      systemd.user.services.novnc = {
        Unit = {
            Description = "noVNC Client Web Server";
            After = [ "wayvnc.service" ];
            BindsTo = [ "wayvnc.service" ];
        };
        Service = {
            ExecStartPre = lib.mkIf config.my.hyprland.enable "${pkgs.writeShellScript "wayvnc-pre-start" ''
               ${pkgs.hyprland}/bin/hyprctl --instance 0 keyword animations:enabled false
            ''}";
            ExecStart = "${pkgs.novnc}/bin/novnc --listen 127.0.0.1:6080 --vnc 127.0.0.1:5900";
            SuccessExitStatus = 143;
        };
        Install.WantedBy = [ "wayvnc.service" ];
      };
      systemd.user.services.wayvnc = {
        Unit = {
          Description = "Wayland VNC Server";
          After = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wayvnc}/bin/wayvnc --address 127.0.0.1:5900  --gpu --log-level info";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
