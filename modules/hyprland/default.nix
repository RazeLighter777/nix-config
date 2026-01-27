{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hyprland;

  hyprlockLoginScript = pkgs.writeShellScript "hyprlock-login" ''
    ${pkgs.hyprlock}/bin/hyprlock --immediate --immediate-render
    status=$?
    if [ "$status" -eq 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch exit
    fi
  '';

  # Helper to keep binds readable
  binds = xs: xs;

in
{
  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      swww
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    home-manager.users.${config.my.user.name} = {

      ############################
      # Programs & Services
      ############################

      programs = {
        hyprshot.enable = true;
        kitty = {
          enable = true;
          settings.confirm_os_window_close = 0;
        };
      };

      services = {
        mako = {
          enable = true;
          settings = {
            actions = true;
            anchor = "top-right";
            border-radius = 0;
            default-timeout = 10000;
            height = 100;
            icons = true;
            layer = "top";
            margin = 10;
            markup = true;
            width = 300;
          };
        };

        hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "hyprlock --immediate --immediate-render";
              before_sleep_cmd = "hyprlock --immediate";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
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
      };

      ############################
      # Cursor
      ############################

      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
      };

      ############################
      # Hyprland
      ############################

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.enable = false;
        xwayland.enable = true;

        extraConfig = ''
          source = ~/.config/hypr/workspaces.conf
          source = ~/.config/hypr/monitors.conf
        '';

        settings = {
          "$mod" = "SUPER";

          env = [
            "XDG_CURRENT_DESKTOP,Hyprland"
          ];

          exec-once = [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME"
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "systemctl --user start graphical-session.target"
          ];

          input = {
            follow_mouse = 1;
            sensitivity = 0;
            touchpad.natural_scroll = true;
          };

          general = {
            gaps_in = 4;
            gaps_out = 8;
            border_size = 2;
            allow_tearing = false;
          };

          decoration = {
            rounding = 6;
            blur = {
              enabled = true;
              size = 3;
              passes = 2;
              new_optimizations = true;
            };
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            focus_on_activate = true;
            animate_manual_resizes = false;
            animate_mouse_windowdragging = false;
          };

          ############################
          # Binds
          ############################

          bindm = binds [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];

          bindl = binds [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
          ];

          binde = binds [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ];

          bind = binds (
            [
              "$mod SHIFT, C, exec, hyprpicker --autocopy"
              "$mod CTRL, C, exec, cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
              "$mod CTRL, S, exec, hyprshot -m region"
              "CTRL ALT, T, exec, kitty"
              "CTRL ALT, C, exec, hyprctl reload"
              "$mod, D, exec, rofi -show drun -replace -i -show-icons"
              "$mod, L, exec, hyprlock"
              "$mod, P, exec, rofi -show p -modi p:rofi-power-menu"
              "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
              "$mod, Q, killactive,"

              # Layout
              "$mod CTRL, D, layoutmsg, removemaster"
              "$mod, I, layoutmsg, addmaster"
              "$mod, J, layoutmsg, cyclenext"
              "$mod, K, layoutmsg, cycleprev"
              "$mod CTRL, Return, layoutmsg, swapwithmaster"
              "$mod SHIFT, I, togglesplit"
              "$mod SHIFT, F, togglefloating"
              "$mod SHIFT, P, pseudo,"

              # Focus / Move
              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"
              "$mod CTRL, left, movewindow, l"
              "$mod CTRL, right, movewindow, r"
              "$mod CTRL, up, movewindow, u"
              "$mod CTRL, down, movewindow, d"
              "$mod ALT, left, swapwindow, l"
              "$mod ALT, right, swapwindow, r"
              "$mod ALT, up, swapwindow, u"
              "$mod ALT, down, swapwindow, d"

              # Workspaces
              "$mod, tab, workspace, m+1"
              "$mod SHIFT, tab, workspace, m-1"
              "$mod, period, workspace, e+1"
              "$mod, comma, workspace, e-1"
              "$mod, U, togglespecialworkspace,"
              "$mod SHIFT, U, movetoworkspace, special"
            ]
            ++ (map (n: "$mod, code:${toString (9 + n)}, workspace, ${toString n}") (lib.range 1 10))
            ++ (map (n: "$mod SHIFT, code:${toString (9 + n)}, movetoworkspace, ${toString n}") (
              lib.range 1 10
            ))
            ++ (map (n: "$mod CTRL, code:${toString (9 + n)}, movetoworkspacesilent, ${toString n}") (
              lib.range 1 10
            ))
            ++ lib.optionals config.my.brightnessctl.enable [
              ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
              ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
            ]
          );

          # Proper Alt-Tab behavior
          bindr = binds [
            "ALT, tab, bringactivetotop"
          ];
        };
      };

      ############################
      # systemd --user services
      ############################

      systemd.user.services = {

        swww = {
          Unit = {
            Description = "swww wallpaper daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.swww}/bin/swww-daemon";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        swww-wallpaper = {
          Unit = {
            Description = "Set wallpaper";
            PartOf = [ "graphical-session.target" ];
            After = [ "swww.service" ];
            Requires = [ "swww.service" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.swww}/bin/swww img %h/Images/wallpapers/big-sur.jpg";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        hyprlock-login = {
          Unit = {
            Description = "Hyprlock login screen";
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = hyprlockLoginScript;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        hyprpolkitagent = {
          Unit = {
            Description = "Hyprland Polkit Agent";
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        cliphist-store = {
          Unit = {
            Description = "Clipboard history";
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
