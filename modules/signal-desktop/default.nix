{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.signal-desktop.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = [ pkgs.signal-desktop ];
    };
  };
}
