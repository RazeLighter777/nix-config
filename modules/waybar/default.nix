{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Include the script from repo, exposed as an executable
  waybar-bandwidth = pkgs.writeShellScript "waybar-bandwidth" ''
    export IPROUTE_BIN=${pkgs.iproute2}/bin/ip
    export AWK_BIN=${pkgs.gawk}/bin/awk
    export DATE_BIN=${pkgs.coreutils}/bin/date
    export PATH=${pkgs.bc}/bin:$PATH
    exec ${pkgs.bash}/bin/bash ${./waybar-bandwidth.sh} "$@"
  '';
in
{
  config = lib.mkIf config.my.waybar.enable {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      pulseaudio
    ];
    home-manager.users.${config.my.user.name} = {
      home.packages = with pkgs; [
        waybar
        nerd-fonts.jetbrains-mono
        playerctl
      ];

      # Place the script into ~/.config/waybar/scripts
      home.file.".config/waybar/scripts/waybar-bandwidth" = {
        source = waybar-bandwidth;
        executable = true;
      };

      programs.waybar = {
        enable = true;

        style = ''
          window#waybar {
            background-color: rgba(30, 30, 30, 0.40);
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.06);
            box-shadow: 0 0 10px rgba(255,100,0,0.20);
            padding: 4px 10px;
            margin: 6px 10px;
          }

          * { font-family: "JetBrainsMono Nerd Font", monospace; font-size: 13px; color: #ddd; }

          #custom-bandwidth,
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
          #tray,
          #mpris {
            background-color: rgba(40,40,40,0.5);
            border-radius: 8px;
            padding: 2px 8px;
            margin: 0 5px;
          }

          #workspaces button { background-color: transparent; border-radius: 8px; padding: 2px 8px; margin: 0 3px; }
          #workspaces button:hover { background-color: rgba(255,255,255,0.06); }
          #workspaces button.active { background-color: rgba(255,140,0,0.25); box-shadow: 0 0 6px rgba(255,140,0,0.35); }
          #workspaces button.urgent { background-color: rgba(220,53,69,0.35); box-shadow: 0 0 6px rgba(220,53,69,0.45); }

          #network.disconnected { color: #ff7a90; }
          #battery.warning { color: #ffcc66; }
          #battery.critical { color: #ff7a90; }
          #bluetooth.connected { color: #73DACA; }

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

          /* State colors */
          #pulseaudio.muted { color: #b3b3b3; }
          #network.disconnected { color: #ff7a90; }
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

        '';

        settings = [
          # === Bottom Bar (workspace + media + sys info) ===
          {
            height = 30;
            layer = "top";
            position = "bottom";

            modules-left = [
              "hyprland/workspaces"
              "mpris"
            ];

            modules-right = [
              "network"
              "pulseaudio"
              "bluetooth"
              "backlight"
              "battery"
              "idle_inhibitor"
              "tray"
            ];

            network = {
              interval = 1;
              format-disconnected = "Disconnected ⚠";
              format-ethernet = "󰈀";
              format-linked = "{ifname} (No IP) ";
              format-wifi = "{essid} ({signalStrength}%) 󰖩";
              on-click = "nm-connection-editor";
            };

            "custom/bandwidth" = {
              exec = "~/.config/waybar/scripts/waybar-bandwidth";
              interval = 1;
              tooltip = false;
              id = "custom-bandwidth";
            };

            "network#ip" = {
              interval = 5;
              format = "{ipaddr} 🌐";
              format-disconnected = "No IP";
              tooltip-format = "{ifname}: {ipaddr}/{cidr}";
            };

            idle_inhibitor = {
              format = " {icon} ";
              format-icons = {
                activated = ""; # eye closed (blocking idle)
                deactivated = ""; # eye open (allow idle)
              };
            };

            clock = {
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              format = "{:%H:%M} ⏱️";
              format-alt = "{:%Y-%m-%d %H:%M:%S}";
            };

            cpu.format = "{usage}% 🖥️";
            cpu.tooltip = false;

            memory.format = "{}% 🧠";

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
          }

          # === Top Bar (optional minimal system info) ===
          {
            height = 30;
            layer = "top";
            position = "top";

            modules-left = [
              "cpu"
              "memory"
              "temperature"
              "network#ip"
              "custom/bandwidth"
            ];

            modules-center = [ "clock" ];
            modules-right = [
              "disk"
            ];

            "custom/bandwidth" = {
              exec = "~/.config/waybar/scripts/waybar-bandwidth";
              interval = 1;
              tooltip = false;
              id = "custom-bandwidth";
            };

            "network#ip" = {
              interval = 5;
              format = "{ipaddr} 🌐";
              format-disconnected = "No IP";
              tooltip-format = "{ifname}: {ipaddr}/{cidr}";
            };

            clock = {
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              format = "{:%H:%M} ⏱️";
              format-alt = "{:%Y-%m-%d %H:%M:%S}";
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

            cpu.format = "{usage}% 🖥️";
            cpu.tooltip = false;

            memory.format = "{}% 🧠";

            "hyprland/mode".format = ''<span style="italic">{}</span>'';
            temperature = {
              critical-threshold = 122;
              format = "{temperatureF}°F 🌡️ ";
            };
          }
        ];
      };
    };
  };
}
