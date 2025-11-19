{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.hyprland.enable {
    environment.systemPackages = [
      pkgs.hyprpolkitagent
      pkgs.rofi-power-menu
    ];
    home-manager.users.${config.my.user.name} = {
      programs.hyprshot = {
        enable = true;
      };
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
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
        extraConfig = ''
          input {
            touchpad {
              natural_scroll = yes
            }
          }
          source = ~/.config/hypr/workspaces.conf
          source = ~/.config/hypr/monitors.conf
          experimental {
            xx_color_management_v4 = true
          }
        '';
        settings = {
          "$mod" = "SUPER";
          exec-once = [
            "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME"
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME"
            "systemctl --user enable --now hypridle.service"
            "systemctl --user enable --now mako.service"
            "nm-applet"
            "systemctl --user start hyprpolkitagent"
            "udiskie"
            (lib.mkIf config.my.blueberry.enable "blueberry-tray")
            "wl-paste --watch cliphist store"
            "wl-clip-persist --clipboard regular"
          ];
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];
          bindl = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ];
          binde = [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ];
          bind = [
            "$mod SHIFT, C, exec, hyprpicker --autocopy"
            "$mod CTRL, C, exec, cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
            "$mod CTRL, S, exec, hyprshot -m region"
            "CTRL ALT, T, exec, kitty"
            "CTRL ALT, C, exec, hyprctl reload"
            "$mod, D, exec, rofi -show drun -replace -i -show-icons -icon-theme 'Tela-dark'"
            "$mod, L, exec, hyprlock"
            "$mod, P, exec, rofi -show p -modi p:rofi-power-menu -show-icons -icon-theme 'Tela-dark'"
            (lib.mkIf config.my.blueberry.enable "$mod, B, exec, blueberry")
            "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
            "$mod, Q, killactive,"
            "$mod CTRL, D, layoutmsg, removemaster"
            "$mod, I, layoutmsg, addmaster"
            "$mod, J, layoutmsg, cyclenext"
            "$mod, K, layoutmsg, cycleprev"
            "$mod CTRL, Return, layoutmsg, swapwithmaster"
            "$mod SHIFT, I, togglesplit"
            "$mod SHIFT, P, pseudo,"
            "$mod SHIFT, F, togglefloating"
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
            (lib.mkIf config.my.brightnessctl.enable ", XF86MonBrightnessUp, exec, brightnessctl s +5%")
            (lib.mkIf config.my.brightnessctl.enable ", XF86MonBrightnessDown, exec, brightnessctl s 5%-")
          ];
        };
      };
      programs.rofi = {
        enable = true;
      };
      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = false;
          splash_offset = 2.0;
          preload = [ "${config.my.user.homeDir}/Images/wallpapers/big-sur.jpg" ];
          wallpaper = [ ", ${config.my.user.homeDir}/Images/wallpapers/big-sur.jpg" ];
        };
      };
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
      };
      programs.kitty = {
        enable = true;
        settings.confirm_os_window_close = 0;
      };
    };
  };
}
