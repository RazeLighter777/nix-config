{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.my.waybar.enable {
    home-manager.users.${config.my.user.name} = {
      home.packages =
        let
          waybar-bandwidth = pkgs.writeShellScriptBin "waybar-bandwidth" ''
            set -euo pipefail

            ip="${pkgs.iproute2}/bin/ip"
            awk="${pkgs.gawk}/bin/awk"
            date="${pkgs.coreutils}/bin/date"

            iface="$($ip route show default 2>/dev/null | $awk 'NR==1{for(i=1;i<=NF;i++) if($i=="dev") {print $(i+1); exit}}')"
            if [[ -z "''${iface:-}" || ! -d "/sys/class/net/$iface/statistics" ]]; then
              echo "🢃 0.00 Mbps 🢁 0.00 Mbps"
              exit 0
            fi

            rx_file="/sys/class/net/$iface/statistics/rx_bytes"
            tx_file="/sys/class/net/$iface/statistics/tx_bytes"
            rx_now="$(cat "$rx_file" 2>/dev/null || echo 0)"
            tx_now="$(cat "$tx_file" 2>/dev/null || echo 0)"
            t_now_ns="$($date +%s%N)"

            state_file="/tmp/waybar-bandwidth-$iface.state"

            if [[ -f "$state_file" ]]; then
              read -r rx_prev tx_prev t_prev_ns < "$state_file" || true
            else
              rx_prev="$rx_now"
              tx_prev="$tx_now"
              t_prev_ns="$t_now_ns"
            fi

            printf '%s %s %s\n' "$rx_now" "$tx_now" "$t_now_ns" > "$state_file"

            $awk \
              -v rx_now="$rx_now" -v tx_now="$tx_now" \
              -v rx_prev="''${rx_prev:-$rx_now}" -v tx_prev="''${tx_prev:-$tx_now}" \
              -v t_now_ns="$t_now_ns" -v t_prev_ns="''${t_prev_ns:-$t_now_ns}" \
              'BEGIN {
                dt = (t_now_ns - t_prev_ns) / 1000000000.0;
                if (dt <= 0) dt = 1.0;

                drx = rx_now - rx_prev;
                dtx = tx_now - tx_prev;
                if (drx < 0) drx = 0;
                if (dtx < 0) dtx = 0;

                down_mbps = (drx * 8.0) / (dt * 1000000.0);
                up_mbps = (dtx * 8.0) / (dt * 1000000.0);

                down_icon = "🢃";
                up_icon = "🢁";
                if (down_mbps > 1.0) down_icon = down_icon "🚀";
                if (up_mbps > 1.0) up_icon = up_icon "🚀";

                printf "%s %.2f Mbps %s %.2f Mbps\n", down_icon, down_mbps, up_icon, up_mbps;
              }'
          '';
        in
        (with pkgs; [
          waybar
          nerd-fonts.jetbrains-mono
          waybar-bandwidth
        ]);

      programs.waybar = {
        enable = true;
        systemd.enable = true;

        style = ''
          /* Transparent dark theme with a subtle glow */
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
          #custom-bandwidth,
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

          /* Bandwidth glyphs sit slightly high vs other modules */
          #custom-bandwidth {
            padding-top: 6px;
            padding-bottom: .5px;
          }

          /* Subtle hover feedback */
          #clock:hover,
          #pulseaudio:hover,
          #network:hover,
          #custom-bandwidth:hover,
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
              "network"
              (lib.mkIf config.my.battery.enable "battery")
              "idle_inhibitor"
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

            clock = {
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              format = "{:%H:%M} ⏱️ ";
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
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = "🔇 {icon} {format_source}";
              format-icons = {
                car = "🚗";
                default = [
                  "🔈"
                  "🔉"
                  "🔊"
                ];
                handsfree = "🎧";
                headphones = "🎧";
                headset = "🎧";
                phone = "📱";
                portable = "📱";
              };
              format-muted = "🔇 {format_source}";
              format-source = "{volume}% 🎤";
              format-source-muted = "🎤✗";
              scroll-step = 5;
              on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
              on-click-right = "pavucontrol";
            };

            "hyprland/mode".format = ''<span style="italic">{}</span>'';
            temperature = {
              critical-threshold = 122;
              format = "{temperatureF}°F 🌡️ ";
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
              format = "{percent}% ☀";
              on-scroll-up = "brightnessctl set +5%";
              on-scroll-down = "brightnessctl set 5%-";
            };
          }
          {
            height = 30;
            layer = "top";
            position = "top";

            modules-center = [ "clock" ];
            modules-left = [
              "cpu"
              "memory"
              "custom/bandwidth"
              "temperature"
            ];
            modules-right = [
              "disk"
            ];

            clock = {
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              format = "{:%H:%M} ⏱️";
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
              format = "{usage}% 🖥️";
              tooltip = false;
            };

            memory.format = "{}% 🧠";

            "custom/bandwidth" = {
              exec = "waybar-bandwidth";
              interval = 1;
              tooltip = false;
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
          }
        ];
      };
    };
  };
}
