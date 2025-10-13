{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.my.waybar.enable {
    home-manager.users.${config.my.user.name}.programs.waybar = {
      enable = true;
      systemd.enable = true;

      style = ''
        ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

        window#waybar {
          background: rgba(30, 30, 30, 0.4); /* semi-transparent dark glass */
          border-radius: 12px;
          border: 1px solid rgba(255, 255, 255, 0.05);
          box-shadow: 0 0 10px rgba(255, 100, 0, 0.2); /* warm glow */
          padding: 4px 10px;
          margin: 6px 10px;
        }

        #taskbar button {
          background: transparent;
          border-radius: 8px;
          padding: 0 10px;
          color: #eee;
        }

        #taskbar button.focused {
          background: rgba(255, 140, 0, 0.3);
          box-shadow: 0 0 5px rgba(255, 140, 0, 0.5);
        }

        #clock,
        #cpu,
        #memory,
        #battery,
        #temperature,
        #pulseaudio,
        #network,
        #tray {
          background: rgba(40, 40, 40, 0.5);
          border-radius: 8px;
          margin: 0 5px;
          padding: 2px 8px;
          color: #ddd;
        }

        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
        }
      '';
      settings = [
        {
          height = 30;
          layer = "top";
          position = "bottom";
          tray.spacing = 10;

          modules-center = [ "hyprland/window" ];
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "pulseaudio"
            "network"
            (lib.mkIf config.my.battery.enable "battery")
            "idle_inhibitor"
            "cpu"
            "memory"
            "temperature"
            "clock"
            "tray"
          ];

          battery = {
            format = "{capacity}% {icon}";
            format-alt = "{time} {icon}";
            format-charging = "{capacity}% ";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            format-plugged = "{capacity}% ";
            states = {
              critical = 15;
              warning = 30;
            };
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          clock = {
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              on-scroll = 1;
              format = {
                months = "<span color='#73DACA'><b>{}</b></span>";
                weekdays = "<span color='#73DACA'><b>{}</b></span>";
                days = "<span color='#9ECE6A'>{}</span>";
                today = "<span color='#D5D5D6'><b><u>{}</u></b></span>";
              };
              actions = {
                on-click-right = "mode";
                on-scroll-up = "shift-up";
                on-scroll-down = "shift-down";
              };
            };
          };

          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };

          memory.format = "{}% ";

          network = {
            interval = 1;
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected ⚠";
            format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
            format-linked = "{ifname} (No IP) ";
            format-wifi = "{essid} ({signalStrength}%) ";
          };

          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-icons = {
              car = "";
              default = [
                ""
                ""
                ""
              ];
              handsfree = "";
              headphones = "";
              headset = "";
              phone = "";
              portable = "";
            };
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            on-click = "pavucontrol";
          };

          "hyprland/mode".format = ''<span style="italic">{}</span>'';
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C";
          };
          "hyprland/workspaces" = {
            format = "{name} {windows}";
            format-window-seperator = " ";
            "workspace-taskbar" = {
              enable = true;
              format = "{icon}";
              icon-size = 20;
              icon-theme = "WhiteSur-dark";
              update-active-window = true;
            };
          };

        }
      ];
    };
  };
}
