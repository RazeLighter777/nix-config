{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.tracee.enable {
    environment.systemPackages = with pkgs; [
      tracee
    ];

    systemd.services.tracee-ebpf = {
      description = "Tracee eBPF Runtime Security and Forensics";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tracee}/bin/tracee-ebpf";
        Restart = "on-failure";
        RestartSec = "5s";

        # Security capabilities
        AmbientCapabilities = [
          "CAP_SYS_RESOURCE"
          "CAP_BPF"
          "CAP_PERFMON"
          "CAP_SYS_ADMIN"
          "CAP_SYS_PTRACE"
          "CAP_NET_ADMIN"
          "CAP_SETPCAP"
          "CAP_SYSLOG"
        ];
        CapabilityBoundingSet = [
          "CAP_SYS_RESOURCE"
          "CAP_BPF"
          "CAP_PERFMON"
          "CAP_SYS_ADMIN"
          "CAP_SYS_PTRACE"
          "CAP_NET_ADMIN"
          "CAP_SETPCAP"
          "CAP_SYSLOG"
        ];

        # Additional hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };
  };
}
