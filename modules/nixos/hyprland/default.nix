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

  luaDir = ./lua;
in
{
  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      awww
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    home-manager.users.${config.my.user.name} = {

      programs = {
        hyprshot.enable = true;
        kitty = {
          enable = true;
          settings.confirm_os_window_close = 0;
        };
      };

      services.hypridle = {
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

      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
      };

      # Hyprland 0.55+ uses Lua for its config. We install hyprland.lua (and
      # friends) directly via xdg.configFile; when hyprland.lua is present the
      # legacy hyprland.conf is ignored, so the home-manager `settings` /
      # `extraConfig` options are intentionally unset here.
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.enable = false;
        xwayland.enable = true;
      };

      xdg.configFile = {
        "hypr/hyprland.lua".source      = luaDir + "/hyprland.lua";
        "hypr/look_and_feel.lua".source = luaDir + "/look_and_feel.lua";
        "hypr/input.lua".source         = luaDir + "/input.lua";
        "hypr/autostart.lua".source     = luaDir + "/autostart.lua";
        "hypr/binds.lua".source         = luaDir + "/binds.lua";
      } // lib.optionalAttrs config.my.brightnessctl.enable {
        "hypr/binds_brightness.lua".source = luaDir + "/binds_brightness.lua";
      };

      systemd.user.services = {

        awww = {
          Unit = {
            Description = "awww wallpaper daemon";
            PartOf = [ "graphical-session.target" ];
          };
          Service = config.my.systemd-sandboxing.user-desktop // {
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.awww}/bin/awww-daemon";
            Restart = "on-failure";
            RestartSec = 2;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        awww-wallpaper = {
          Unit = {
            Description = "Set wallpaper";
            PartOf = [ "graphical-session.target" ];
            After = [ "awww.service" ];
            Requires = [ "awww.service" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.awww}/bin/awww img %h/.local/state/hyprlock-wallpaper";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        awww-sync = {
          Unit = {
            Description = "Sync awww wallpaper from symlink";
            PartOf = [ "graphical-session.target" ];
            After = [ "awww.service" ];
            Requires = [ "awww.service" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${hyprlandEnvWrapper} ${pkgs.awww}/bin/awww img %h/.local/state/hyprlock-wallpaper";
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
        awww-sync = {
          Unit.Description = "Watch wallpaper symlink for awww";
          Path.PathChanged = "%h/.local/state/hyprlock-wallpaper";
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
