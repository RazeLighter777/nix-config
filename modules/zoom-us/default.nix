{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.zoom-us.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = [ pkgs.zoom-us ];
    };
  };
}
