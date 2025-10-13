{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.mako.enable {
    home-manager.users.${config.my.user.name} = {
      services.mako = {
        enable = true;
        settings = {
          "actionable=true" = {
            anchor = "top-left";
          };
          actions = true;
          anchor = "top-right";
          border-radius = 0;
          default-timeout = 10000;
          height = 100;
          icons = true;
          ignore-timeout = false;
          layer = "top";
          margin = 10;
          markup = true;
          width = 300;
        };
      };
    };
  };
}