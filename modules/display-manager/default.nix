{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.displayManager.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd 'uwsm start hyprland'";
        user = "greeter";
      };
    };
    users.users.greeter = {
      isNormalUser = false;
      description = "greetd greeter user";
      extraGroups = [
        "video"
        "audio"
      ];
      linger = true;
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
    environment.systemPackages = [ pkgs.tuigreet ];
    programs.uwsm.enable = true;
    programs.uwsm.package = pkgs.uwsm;
    programs.uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "${config.my.user.homeDir}/.nix-profile/bin/Hyprland";
    };
    services.xserver.desktopManager.runXdgAutostartIfNone = true;
  };
}
