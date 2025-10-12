{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.gnome-keyring.enable {
    home-manager.users.${config.my.user.name}.services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}
