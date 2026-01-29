{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.mako.enable {
    environment.systemPackages = with pkgs; [
      libnotify
      bc
    ];
    home-manager.users.${config.my.user.name} = {
      home.file.".local/bin/mako-volume-notify" = {
        source = ./mako-volume-notify.sh;
        executable = true;
      };
      home.file.".local/bin/mako-brightness-notify" = {
        source = ./mako-brightness-notify.sh;
        executable = true;
      };
      services.mako = {
        enable = true;
        settings = {
          "actionable=true" = {
            anchor = "top-left";
          };
          actions = true;
          anchor = "top-right";
          border-radius = 15;
          default-timeout = 10000;
          height = 100;
          group-by = "app-name";
          icons = true;
          ignore-timeout = false;
          layer = "overlay";
          margin = 10;
          markup = true;
          width = 300;
          "app-name=wp-vol" = {
            layer = "overlay";
            history = 0;
            anchor = "top-center";
            # Group all volume notifications together
            group-by = "app-name";
            # Hide the group-index
            format = "<b>🕨 %s</b>\\n%b";
          };
          "app-name=bctl-bright" = {
            layer = "overlay";
            history = 0;
            anchor = "top-center";
            # Group all brightness notifications together
            group-by = "app-name";
            # Hide the group-index
            format = "<b>🔆 %s</b>\\n%b";
          };
        };
      };
    };
  };
}
