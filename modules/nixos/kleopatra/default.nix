{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.kleopatra.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages = [ pkgs.kdePackages.kleopatra ];
    };
  };
}
