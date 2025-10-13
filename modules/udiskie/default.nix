{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.vscode.enable {
    home-manager.users.${config.my.user.name}.programs.vscode = {
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
