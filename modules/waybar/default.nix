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
        window#waybar {
          background-color: rgba(30, 30, 30, 0.40);
          border-radius: 12px;
          border-style: solid;
          border-width: 1px;
          border-color: rgba(255, 255, 255, 0.06);
          box-shadow: 0 0 10px rgba(255, 100, 0, 0.20);
          padding: 4px 10px;
          margin: 6px 10px;
        }

        /* Typography */
        * {
          font-family: "JetBrainsMono Nerd Font", monospace;
          font-size: 13px;
          color: #ddd;
        }

        /* Common pill style for modules */
        #clock,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #pulseaudio,
        #network,
        #battery,
        #idle_inhibitor,
        #backlight,
        #bluetooth,
        #tray {
          background-color: rgba(40, 40, 40, 0.50);
          border-radius: 8px;
          padding: 2px 8px;
          margin: 0 5px;
        }

        /* Subtle hover feedback */
        #clock:hover,
        #pulseaudio:hover,
        #network:hover,
        #battery:hover,
        #idle_inhibitor:hover,
        #backlight:hover,
        #bluetooth:hover {
          box-shadow: 0 0 4px rgba(255, 255, 255, 0.08);
        }

        /* Workspaces */
        #workspaces button {
          background-color: transparent;
          border-radius: 8px;
          padding: 2px 8px;
          margin: 0 3px;
        }
        #workspaces button:hover {
          background-color: rgba(255, 255, 255, 0.06);
        }
        #workspaces button.active {
          background-color: rgba(255, 140, 0, 0.25);
          box-shadow: 0 0 6px rgba(255, 140, 0, 0.35);
        }
        #workspaces button.urgent {
          background-color: rgba(220, 53, 69, 0.35);
          box-shadow: 0 0 6px rgba(220, 53, 69, 0.45);
        }

        /* State colors */
        #pulseaudio.muted { color: #b3b3b3; }
        #network.disconnected { color: #ff7a90; }
        #battery.warning { color: #ffcc66; }
        #battery.critical { color: #ff7a90; }
        
        /* Bluetooth states */
        #bluetooth.disabled,
        #bluetooth.off,
        #bluetooth.on,
        #bluetooth.no-controller {
          opacity: 0;
          margin: 0;
          padding: 0;
        }
        #bluetooth.connected { color: #73DACA; }
      '';
      settings = [
        {
          height = 30;
          layer = "top";
          position = "bottom";
          tray = {
            spacing = 10;
            icon-size = 16;
          };

          modules-center = [ "hyprland/window" ];
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-right = [
            (lib.mkIf config.my.brightnessctl.enable "backlight")
            "pulseaudio"
            "bluetooth"
            "network"
            (lib.mkIf config.my.battery.enable "battery")
            "idle_inhibitor"
            "cpu"
            "memory"
            "disk"
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
            format = " {icon} ";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          bluetooth = {
            format = " {status}";
            format-connected = " {device_alias} ({num_connections})";
            format-connected-battery = " {device_alias} {device_battery_percentage}%";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            on-click = (lib.mkIf config.my.blueberry.enable "blueberry" );
          };

          clock = {
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            format = "{:%H:%M}  ";
            format-alt = "{:%Y-%m-%d  %H:%M:%S}";
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
            on-click = "nm-connection-editor";
          };

          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              handsfree = "";
              headphones = "";
              headset = "";
              phone = "";
              portable = "";
            };
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            scroll-step = 5;
            on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            on-click-right = "pavucontrol";
          };

          "hyprland/mode".format = ''<span style="italic">{}</span>'';
          temperature = {
            critical-threshold = 122;
            format = "{temperatureF}°F";
          };
          disk = {
            interval = 30;
            format = "{percentage_used}% ({specific_used:0.1f}/{specific_total:0.1f}GB) 🖴";
            unit = "GB";
            states = {
              warning = 15;
              critical = 2;
            };
          };
          "hyprland/workspaces" = {
            format = "{name} {windows}";
            format-window-separator = " ";
            "workspace-taskbar" = {
              enable = true;
              format = "{icon}";
              icon-size = 20;
              icon-theme = "Tela-dark";
              update-active-window = true;
            };
          };

          "hyprland/window" = {
            max-length = 80;
            separate-outputs = false;
          };

          backlight = {
            format = "{percent}% ";
            on-scroll-up = "brightnessctl set +5%";
            on-scroll-down = "brightnessctl set 5%-";
          };

        }
      ];
    };
  };
}
