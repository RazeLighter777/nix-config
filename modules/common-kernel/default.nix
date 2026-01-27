{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.commonKernel;
in
{
  options.my.commonKernel.enable = lib.mkEnableOption "Enable shared kernel defaults";

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_18;
    boot.kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "udev.log_level=3"
      "boot.shell_on_fail"
      "elevator=kyber"
      "mitigations=off"
      "preempt=full"
      "nohz=on"
      "rcu_nocbs=0-15"
      "rcu_nocb_poll"
      # Memory performance - Zen 4 has excellent memory controller
      "amd_iommu=on"
      "iommu=pt" # Pass-through mode for better performance with VMs
      # Disable kernel watchdog (slight performance improvement)
      "nowatchdog"

      # Transparent Hugepages for better memory performance
      "transparent_hugepage=always"

      # AMD Zen 4 specific optimizations
      "amd_pstate=active" # Use AMD P-State EPP driver for better power/perf
      "amd_prefcore=enable" # Enable preferred core ranking (boost best cores)

      # Reduce C-state latency for gaming (Zen 4 specific)
      "processor.max_cstate=1" # Balance between performance and power

      # TSC clocksource for lower latency (Ryzen 7600 has stable TSC)
      "tsc=reliable"
      "clocksource=tsc"
    ];
    boot.kernel.sysctl = {
      # start writeback early
      "vm.dirty_background_ratio" = 2;
      "vm.dirty_ratio" = 6;

      # reduce long writeback stalls
      "vm.dirty_expire_centisecs" = 1500; # 15s
      "vm.dirty_writeback_centisecs" = 100; # 1s
      # swap
      "vm.swappiness" = 1;
      "vm.vfs_cache_pressure" = 25;
      "vm.page-cluster" = 0;
      "vm.transparent_hugepage" = "madvise";
      "vm.watermark_scale_factor" = 200; # Scale down memory reclaim
      #networking
      "net.core.default_qdisc" = "fq_codel";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 8192;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_mtu_probing" = 1;
    };
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
    systemd.settings.Manager = {
      DefaultCPUAccounting = true;
      DefaultIOAccounting = true;
    };
    systemd.slices."system.slice".sliceConfig = {
      CPUWeight = 100;
      IOWeight = 100;
    };

    systemd.slices."user.slice".sliceConfig = {
      CPUWeight = 300;
      IOWeight = 300;
    };

    systemd.slices."app.slice".sliceConfig = {
      CPUWeight = 200;
      IOWeight = 200;
    };
    systemd.user.extraConfig = ''
      DefaultSlice=app.slice
    '';
    services.udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme?n?", ATTR{bdi/read_ahead_kb}="4096"
      ACTION=="add|change", KERNEL=="nvme?n?", ATTR{queue/nr_requests}="64"
      ACTION=="add|change", KERNEL=="nvme?n?", ATTR{queue/scheduler}="kyber"
    '';
    boot.consoleLogLevel = 0;
    boot.loader.timeout = 0;
    boot.initrd.verbose = false;
    boot.initrd.systemd.enable = true;
    security.rtkit.enable = true;
    powerManagement.cpuFreqGovernor = "performance";
    services.irqbalance.enable = true;
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 20;
      extraArgs = [
        # Avoid killing important system and desktop processes
        "--avoid"
        "^(systemd|kernel|init|dbus|NetworkManager|pipewire|wireplumber|pulse)$"
        "--avoid"
        "^(gnome-shell|plasmashell|kwin|xorg|wayland|sway|hyprland)$"
        "--avoid"
        "^(gdm|sddm|lightdm|greetd)$"
        # Prefer killing these types of processes first
        "--prefer"
        "^(chrome|chromium|firefox|electron)$"
        "--prefer"
        "^(java|node|python|ruby)$"
      ];
    };
  };
}
