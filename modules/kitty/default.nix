{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.kitty.enable {
    home-manager.users.${config.my.user.name}.programs.kitty = {
      enable = true;
      settings = {
        background_opacity = 0.7;
      };
    };
  };
}
