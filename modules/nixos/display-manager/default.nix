{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.displayManager.enable {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.displayManager.autoLogin = {
      enable = true;
      user = config.my.user.name;
    };

    services.displayManager.defaultSession = "hyprland-uwsm";

    programs.uwsm.enable = true;
    programs.uwsm.package = pkgs.uwsm;
    programs.uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/start-hyprland";
    };
    services.xserver.desktopManager.runXdgAutostartIfNone = true;

  };
}
