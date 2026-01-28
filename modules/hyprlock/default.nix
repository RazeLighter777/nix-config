{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.hyprland.enable {
    home-manager.users.${config.my.user.name} = {
      home.file = {
        ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
        ".config/hypr/hyprlock-wallpaper-sync.sh" = {
          source = ./hyprlock-wallpaper-sync.sh;
          executable = true;
        };
        ".config/hypr/hyprlock-run.sh" = {
          source = ./hyprlock-run.sh;
          executable = true;
        };
      };

      systemd.user.services.hyprlock-wallpaper-sync = {
        Unit = {
          Description = "Sync Hyprlock wallpaper from swww";
        };
        Service = config.my.systemd-sandboxing.user-desktop // {
          Type = "oneshot";
          ExecStart = "%h/.config/hypr/hyprlock-wallpaper-sync.sh";
        };
      };
    };
  };
}
