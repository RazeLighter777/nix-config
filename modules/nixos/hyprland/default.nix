{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hyprland;

  hyprlockLoginScript = pkgs.writeShellScript "hyprlock-login" ''
    "$HOME/.config/hypr/hyprlock-run.sh" --immediate --immediate-render
    status=$?
    if [ "$status" -eq 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch exit
    fi
  '';

  hyprlandEnvWrapper = pkgs.writeShellScript "hyprland-env-wrapper" ''
    set -euo pipefail

    runtime_dir="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}"

    if [ -n "''${WAYLAND_DISPLAY:-}" ] && [ ! -S "$runtime_dir/$WAYLAND_DISPLAY" ]; then
      unset WAYLAND_DISPLAY
    fi

    if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
      for _ in $(seq 1 50); do
        if ${pkgs.hyprland}/bin/hyprctl instances -j >/dev/null 2>&1; then
          socket="$(${pkgs.hyprland}/bin/hyprctl instances -j | ${pkgs.jq}/bin/jq -r '.[0]["wl_socket"] // empty')"
          if [ -n "$socket" ] && [ -S "$runtime_dir/$socket" ]; then
            export WAYLAND_DISPLAY="$socket"
            break
          fi
        fi
        sleep 0.2
      done
    fi

    export XDG_CURRENT_DESKTOP="''${XDG_CURRENT_DESKTOP:-Hyprland}"
    export QT_QPA_PLATFORM="''${QT_QPA_PLATFORM:-wayland}"

    if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
      echo "hyprland-env-wrapper: WAYLAND_DISPLAY not available yet" >&2
      exit 1
    fi

    exec "$@"
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

        hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "~/.config/hypr/hyprlock-run.sh --immediate --immediate-render";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
            };

            listener = [
              {
                timeout = 900;
                on-timeout = "~/.config/hypr/hyprlock-run.sh";
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
            active_opacity = 1.0;
            inactive_opacity = 0.9;
            blur = {
              enabled = true;
              size = 3;
              passes = 2;
              new_optimizations = true;
              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "popin,0.175,0.885,0.32,1.275"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
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
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.local/bin/mako-volume-notify"
          ];

          binde = binds [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/.local/bin/mako-volume-notify"
          ];

          bind = binds (
            [
              "$mod SHIFT, C, exec, hyprpicker --autocopy"
              "$mod CTRL, C, exec, cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
              "$mod CTRL, S, exec, hyprshot -m region"
              "CTRL ALT, T, exec, kitty"
              "CTRL ALT, C, exec, hyprctl reload"
              "$mod, D, exec, rofi -show drun -replace -i -show-icons"
              "$mod, L, exec, ~/.config/hypr/hyprlock-run.sh"
              "$mod, P, exec, rofi -show p -modi p:rofi-power-menu"
              "$mod, SPACE, exec, ~/.config/rofi/rofi-system-menu.sh"
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
              ", XF86MonBrightnessUp, exec, brightnessctl s +5% && ~/.local/bin/mako-brightness-notify"
              ", XF86MonBrightnessDown, exec, brightnessctl s 5%- && ~/.local/bin/mako-brightness-notify"
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
          };
          Service = config.my.systemd-sandboxing.user-desktop // {
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.swww}/bin/swww-daemon";
            Restart = "on-failure";
            RestartSec = 2;
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
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.swww}/bin/swww img %h/.local/state/hyprlock-wallpaper";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        swww-sync = {
          Unit = {
            Description = "Sync swww wallpaper from symlink";
            PartOf = [ "graphical-session.target" ];
            After = [ "swww.service" ];
            Requires = [ "swww.service" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.swww}/bin/swww img %h/.local/state/hyprlock-wallpaper";
          };
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
            After = [ "graphical-session.target" ];
          };
          Service = config.my.systemd-sandboxing.user-desktop // {
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
            Restart = "always";
            RestartSec = 2;
            NoNewPrivileges = false;
            RestrictSUIDSGID = false;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        cliphist-store = {
          Unit = {
            Description = "Clipboard history";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = config.my.systemd-sandboxing.user-desktop // {
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
            Restart = "always";
            RestartSec = 2;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };

      systemd.user.paths = {
        swww-sync = {
          Unit = {
            Description = "Watch wallpaper symlink for swww";
          };
          Path = {
            PathChanged = "%h/.local/state/hyprlock-wallpaper";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
