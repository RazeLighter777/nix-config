{
  config,
  lib,
  ...
}:

{
  # This module defines reusable systemd sandboxing configurations
  # that can be applied to services for improved security.

  options.my.systemd-sandboxing = {
    # Strict sandboxing profile - maximum isolation
    strict = lib.mkOption {
      type = lib.types.attrs;
      default = {
        # Filesystem protections
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        DevicePolicy = "closed";

        # Namespace isolation
        PrivateNetwork = false; # Often needs network, override if not
        PrivateUsers = true;
        PrivateIPC = true;

        # Capabilities
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        AmbientCapabilities = "";

        # System calls
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@privileged"
          "~@module"
          "~@raw-io"
          "~@reboot"
          "~@mount"
          "~@obsolete"
          "~@swap"
          "~@debug"
        ];

        # Restrict various features
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;

        # Misc hardening
        RemoveIPC = true;
        UMask = "0077";
        DynamicUser = false; # Set to true when service doesn't need a specific user
      };
      description = "Strict systemd sandboxing profile with maximum isolation";
    };

    # Moderate sandboxing profile - balanced security and compatibility
    moderate = lib.mkOption {
      type = lib.types.attrs;
      default = {
        # Filesystem protections
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        DevicePolicy = "closed";

        # Capabilities
        NoNewPrivileges = true;

        # System calls
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@privileged"
          "~@clock"
          "~@module"
          "~@mount"
          "~@reboot"
          "~@swap"
        ];

        # Restrict various features
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;

        # Misc hardening
        UMask = "0027";
      };
      description = "Moderate systemd sandboxing profile balancing security and compatibility";
    };

    # User desktop profile - safe defaults for GUI/user services (keeps $HOME accessible)
    user-desktop = lib.mkOption {
      type = lib.types.attrs;
      default = config.my.systemd-sandboxing.moderate // {
        ProtectHome = false;
        DevicePolicy = "auto";
        PrivateDevices = false;
      };
      description = "User/desktop-friendly sandboxing profile (HOME accessible)";
    };

    # Basic sandboxing profile - minimal restrictions
    basic = lib.mkOption {
      type = lib.types.attrs;
      default = {
        # Filesystem protections
        ProtectSystem = "true";
        PrivateTmp = true;
        ProtectKernelModules = true;

        # Capabilities
        NoNewPrivileges = true;

        # Restrict various features
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Misc hardening
        UMask = "0022";
      };
      description = "Basic systemd sandboxing profile with minimal restrictions";
    };

    # Network isolated profile - for services that don't need network
    network-isolated = lib.mkOption {
      type = lib.types.attrs;
      default = config.my.systemd-sandboxing.strict // {
        PrivateNetwork = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        IPAddressDeny = "any";
      };
      description = "Network isolated sandboxing profile (based on strict profile)";
    };

    # Web service profile - for services that serve web content
    web-service = lib.mkOption {
      type = lib.types.attrs;
      default = config.my.systemd-sandboxing.moderate // {
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        SystemCallFilter = [
          "@system-service"
          "@network-io"
          "~@privileged"
        ];
      };
      description = "Sandboxing profile for web services";
    };
  };

  config = {
    # No packages to install, just configuration
  };
}
