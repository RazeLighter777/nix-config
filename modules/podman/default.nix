{ lib, config ... }:
{
  virtualisation = {
  containers.enable = true;
  podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
  };
};

  users.users.${config.my.user.name}= { # replace `<USERNAME>` with the actual username
    extraGroups = [
      "podman"
    ];
  }
}
