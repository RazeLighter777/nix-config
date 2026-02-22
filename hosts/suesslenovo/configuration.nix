{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];
  my = {
    hyprland.enable = true;
    displayManager.enable = true;
    waybar.enable = true;
    brightnessctl.enable = true;
    # Rely on mkDefault for rest (no NVIDIA / OBS / XMRig)
    kwallet.enable = true;
    battery.enable = true;
    stylix.enable = true;
    bluedevil.enable = true;
    pinpam.enable = true;
    dolphin.enable = true;
    qflipper.enable = true;
    signal-desktop.enable = true;
    virt-manager.enable = true;
    devtools.enable = true;
    ghidra-bin.enable = true;
    okteta.enable = true;
  };
  networking.hostName = "suesslenovo";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Kernel base config + plymouth handled by my.commonKernel / my.plymouth
  # Timezone, locale, direnv now provided by common module (override here if needed)
  users.users.${config.my.user.name} = {
    isNormalUser = true;
    description = "${config.my.user.name}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "dialout"
      "tty"
    ];
  };
  # Host-specific extra packages beyond common + hyprland extras
  environment.systemPackages = with pkgs; [ mpv ];
  hardware.graphics.enable = true;
  nix.settings = {
    substituters = [ "s3://nix?endpoint=s3.prizrak.me&region=us-east-1&profile=default" ];
    trusted-public-keys = [ "prizrak.me:Hk9hSoa/uKOc4cEu8Tu7a4XRkkG08HBs8fQC6nhcuds=" ];
    builders-use-substitutes = true;
  };
  nix.trustedUsers = [
    config.my.user.name
    "root"
  ];
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/etc/age/key.txt";
    templates."nix-aws.env" = {
      owner = "root";
      mode = "0400";
      content = ''
        AWS_ACCESS_KEY_ID=${config.sops.placeholder."s3/access_key_id"}
        AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."s3/secret_access_key"}
        AWS_ENDPOINT_URL_S3=https://s3.prizrak.me
        AWS_EC2_METADATA_DISABLED=true
        AWS_PROFILE=default
      '';
    };
    secrets = {
      "s3/access_key_id" = {
        owner = config.my.user.name;
        mode = "0400";
      };
      "s3/secret_access_key" = {
        owner = config.my.user.name;
        mode = "0400";
      };
      "nix/builder_ssh_key" = {
        owner = "root";
        path = "/root/.ssh/remote-builder-id_ed25519";
        mode = "0400";
      };
    };
  };
  systemd.services.nix-daemon.serviceConfig.EnvironmentFile = lib.mkAfter [
    config.sops.templates."nix-aws.env".path
  ];
  nix.buildMachines = [
    {
      hostName = "princessbelongsto.me";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      sshUser = "root";
      sshKey = "/root/.ssh/remote-builder-id_ed25519";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
        "benchmark"
      ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    	  builders-use-substitutes = true
    	'';
  programs.ssh.extraConfig = ''
    Host princessbelongsto.me
      Port 22223
      User root
      IdentityFile /root/.ssh/remote-builder-id_ed25519
  '';
  # SSH enabled via networking module
  # NetworkManager enabled in networking module
  networking.firewall.allowedTCPPorts = [
    22
  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  system.stateVersion = "25.11";
  # Docker enabled via docker module
  # Steam enabled via my.steam module
}
