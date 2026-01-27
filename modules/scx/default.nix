{ config, lib, pkgs, ... }:
let
  cfg = config.my.scx;
in
{
  options.my.scx.enable = lib.mkEnableOption "Enable sched_ext (scx) tooling and run scx_lavd";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.scx.full
    ];

    systemd.services.scx-lavd = {
      description = "bpfland sched_ext scheduler";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.scx.full}/bin/scx_bpfland";
        Restart = "on-failure";
        RestartSec = "2s";
      };
    };
  };
}
