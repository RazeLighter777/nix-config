{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.okular.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = [ pkgs.kdePackages.okular ];
    };
  };
}
