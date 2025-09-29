{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.my.hyprland.enable {
    home-manager.users.${config.my.user.name} = {
      wayland.windowManager.hyprland = {
        enable = true; package = pkgs.hyprland; xwayland.enable = true;
        settings = {
          "$mod" = "SUPER";
          exec-once = [ "nm-applet" "wayvnc 0.0.0.0" "hyprnotify" ];
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];
          bind = [
            "CTRL ALT, T, exec, kitty"
            "CTRL ALT, C, exec, hyprctl reload"
            "$mod, D, exec, wofi --show drun -i --prompt 'Search...'"
            "$mod, L, exec, hyprlock"
            "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
            "$mod, Q, killactive,"
            "$mod CTRL, D, layoutmsg, removemaster"
            "$mod, I, layoutmsg, addmaster"
            "$mod, J, layoutmsg, cyclenext"
            "$mod, K, layoutmsg, cycleprev"
            "$mod CTRL, Return, layoutmsg, swapwithmaster"
            "$mod SHIFT, I, togglesplit"
            "$mod, P, pseudo,"
            "$mod, M, exec, hyprctl dispatch splitratio 0.3"
            "$mod, G, togglegroup"
            "$mod CTRL, tab, changegroupactive"
            "ALT, tab, cyclenext"
            "ALT, tab, bringactivetotop"
            "$mod SHIFT, left, resizeactive,-50 0"
            "$mod SHIFT, right, resizeactive,50 0"
            "$mod SHIFT, up, resizeactive,0 -50"
            "$mod SHIFT, down, resizeactive,0 50"
            "$mod CTRL, left, movewindow, l"
            "$mod CTRL, right, movewindow, r"
            "$mod CTRL, up, movewindow, u"
            "$mod CTRL, down, movewindow, d"
            "$mod ALT, left, swapwindow, l"
            "$mod ALT, right, swapwindow, r"
            "$mod ALT, up, swapwindow, u"
            "$mod ALT, down, swapwindow, d"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            "$mod, tab, workspace, m+1"
            "$mod SHIFT, tab, workspace, m-1"
            "$mod SHIFT, U, movetoworkspace, special"
            "$mod, U, togglespecialworkspace,"
            "$mod, code:10, workspace, 1"
            "$mod, code:11, workspace, 2"
            "$mod, code:12, workspace, 3"
            "$mod, code:13, workspace, 4"
            "$mod, code:14, workspace, 5"
            "$mod, code:15, workspace, 6"
            "$mod, code:16, workspace, 7"
            "$mod, code:17, workspace, 8"
            "$mod, code:18, workspace, 9"
            "$mod, code:19, workspace, 10"
            "$mod SHIFT, code:10, movetoworkspace, 1"
            "$mod SHIFT, code:11, movetoworkspace, 2"
            "$mod SHIFT, code:12, movetoworkspace, 3"
            "$mod SHIFT, code:13, movetoworkspace, 4"
            "$mod SHIFT, code:14, movetoworkspace, 5"
            "$mod SHIFT, code:15, movetoworkspace, 6"
            "$mod SHIFT, code:16, movetoworkspace, 7"
            "$mod SHIFT, code:17, movetoworkspace, 8"
            "$mod SHIFT, code:18, movetoworkspace, 9"
            "$mod SHIFT, code:19, movetoworkspace, 10"
            "$mod SHIFT, bracketleft, movetoworkspace, -1"
            "$mod SHIFT, bracketright, movetoworkspace, +1"
            "$mod CTRL, code:10, movetoworkspacesilent, 1"
            "$mod CTRL, code:11, movetoworkspacesilent, 2"
            "$mod CTRL, code:12, movetoworkspacesilent, 3"
            "$mod CTRL, code:13, movetoworkspacesilent, 4"
            "$mod CTRL, code:14, movetoworkspacesilent, 5"
            "$mod CTRL, code:15, movetoworkspacesilent, 6"
            "$mod CTRL, code:16, movetoworkspacesilent, 7"
            "$mod CTRL, code:17, movetoworkspacesilent, 8"
            "$mod CTRL, code:18, movetoworkspacesilent, 9"
            "$mod CTRL, code:19, movetoworkspacesilent, 10"
            "$mod CTRL, bracketleft, movetoworkspacesilent, -1"
            "$mod CTRL, bracketright, movetoworkspacesilent, +1"
            "$mod, period, workspace, e+1"
            "$mod, comma, workspace, e-1"
          ];
        };
      };
      programs.wofi.enable = true;
      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on"; splash = false; splash_offset = 2.0;
          preload = [ "${config.my.user.homeDir}/Images/wallpapers/big-sur.jpg" ];
          wallpaper = [ ", ${config.my.user.homeDir}/Images/wallpapers/big-sur.jpg" ];
        };
      };
      gtk = {
        enable = true;
        cursorTheme = { name = "Quintom_Snow"; size = 24; };
        iconTheme = { name = "WhiteSur-dark"; package = pkgs.whitesur-icon-theme; };
        theme = {
          name = "WhiteSur-Dark";
          package = pkgs.whitesur-gtk-theme.override {
            altVariants = [ "all" ]; colorVariants = [ "dark" ]; themeVariants = [ "default" ]; iconVariant = "tux"; nautilusStyle = "glassy";
          };
        };
      };
      home.pointerCursor = {
        gtk.enable = true; x11.enable = true; hyprcursor.enable = true;
        package = pkgs.rose-pine-cursor; name = "BreezeX-RosePine-Linux";
      };
      programs.kitty = { enable = true; settings.confirm_os_window_close = 0; };
    };
  };
}
