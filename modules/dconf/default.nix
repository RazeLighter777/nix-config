{ config, lib, ... }:
{
  config = lib.mkIf config.my.dconf.enable {
    home-manager.users.${config.my.user.name}.dconf.settings."org/cinnamon/desktop/applications/terminal" = { };
  };
}
