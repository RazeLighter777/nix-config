{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.calibre.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = [ pkgs.calibre ];
    };
  };
}
