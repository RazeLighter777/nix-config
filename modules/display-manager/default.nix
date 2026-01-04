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

    services.displayManager.defaultSession = "hyprland";

    environment.etc."sddm.conf.d/hyprland-autologin.conf".text = ''
      [Autologin]
      Session=hyprland
      User=${config.my.user.name}
    '';

    services.displayManager.sessionPackages = [
      (pkgs.stdenvNoCC.mkDerivation {
        name = "hyprland-uwsm-session";
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/wayland-sessions
          cat > $out/share/wayland-sessions/hyprland.desktop <<EOF
          [Desktop Entry]
          Name=Hyprland
          Comment=Hyprland compositor managed by UWSM
          Exec=uwsm start -F -- ${pkgs.hyprland}/bin/Hyprland
          Type=Application
          EOF
        '';
        passthru.providedSessions = [ "hyprland" ];
      })
    ];

    programs.uwsm.enable = true;
    programs.uwsm.package = pkgs.uwsm;
    programs.uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "${pkgs.hyprland}/bin/Hyprland";
    };

    services.xserver.desktopManager.runXdgAutostartIfNone = true;
  };
}
