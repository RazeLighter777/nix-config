{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.kav;
  inherit (lib) mkIf;

  yaraRulesFromRepos =
    repos:
    pkgs.linkFarm "yara-rules" (
      lib.mapAttrsToList (
        name: repo:
        let
          fetched = builtins.fetchGit {
            url = repo.url;
            ref = if repo.ref != null then repo.ref else "HEAD";
          };
        in
        {
          name = name;
          path = fetched;
        }
      ) repos
    );
in
{
  config = mkIf cfg.enable {
    # Enable the kav security module
    security.kav = {
      enable = false;

      # Use the current kernel
      kernel = config.boot.kernelPackages.kernel;

      # Default directories (can be overridden if needed)
      rulesDir = "/etc/kav/rules/current";
      configDir = "/etc/kav/config/current";
      jailDir = "/var/kav/jail";
      casDir = "/var/lib/kav/cas";
      stateDir = "/var/lib/kav/state";
      socketPath = "/var/run/kav.sock";
      # Configure which kav programs to run
      # Uses the defaults from the kav module which includes:
      # broker, warden, syslog, match, fanotify, ebpf-setuid, ebpf-chmod
      # programs = {
      #   # broker = {
      #   #   enable = true;
      #   #   command = "broker";
      #   #   enabled = true;
      #   # };
      #   # warden = {
      #   #   enable = true;
      #   #   command = "jail";
      #   #   args = "warden";
      #   #   enabled = true;
      #   # };
      #   # syslog = {
      #   #   enable = true;
      #   #   command = "syslog";
      #   #   enabled = true;
      #   # };
      #   # match = {
      #   #   enable = true;
      #   #   command = "match";
      #   #   enabled = true;
      #   # };
      #   # fanotify = {
      #   #   enable = true;
      #   #   command = "fanotify";
      #   #   args = "-d /home:rwx:notify -d /tmp:rwx:notify";
      #   #   enabled = true;
      #   # };
      #   # ebpf-setuid = {
      #   #   enable = true;
      #   #   command = "ebpf";
      #   #   args = "setuid";
      #   #   enabled = true;
      #   # };
      #   ebpf-chmod = {
      #     enable = false;
      #     command = "ebpf";
      #     args = "chmod";
      #     enabled = true;
      #   };
      # };

      # Add YARA rule repositories
    };
  };
}
