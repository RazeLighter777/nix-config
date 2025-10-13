{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.udiskie.enable {
    services.udisks2.enable = true;
    home-manager.users.${config.my.user.name} = {
      services.udiskie = {
        enable = true;
        notify = true;
        settings = {
          program_options = {
            udisks_version = 2;
            tray = true;
          };
          icon_names.media = [ "media-optical" ];
        };
      };
    };
  };
}
