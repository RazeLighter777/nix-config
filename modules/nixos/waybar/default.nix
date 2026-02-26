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

  batteryEnabled = config.my.battery.enable;
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
        nerd-fonts.fira-code
        playerctl
        cava
      ];

      xdg.configFile."autostart/nm-applet.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=NetworkManager Applet
        Hidden=true
      '';

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

          * {
              all: unset;
              font-size: 13px;
              font-family: 'FiraCode Nerd Font', monospace;
              font-feature-settings: '"zero", "tnum", "ss01", "ss02", "ss03", "cv01"';
              animation-timing-function: steps(12);
              animation-duration: 0.3s;
              transition: all 0.3s cubic-bezier(0.79, 0.33, 0.14, 0.53);
          }

          #custom-bandwidth,
          #custom-system-menu,
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
          #power-profiles-daemon,
          #mpris {
            background-color: rgba(40,40,40,0.5);
            border-radius: 8px;
            padding: 2px 8px;
            margin: 0 5px;
          }

          #pulseaudio,
          #custom-bandwidth
          {
            margin-top: 6px;
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
          (
            {
              height = 30;
              layer = "top";
              position = "bottom";

              modules-left = [
                "custom/system-menu"
                "hyprland/workspaces"
              ];

              modules-right = [
                "network"
                "pulseaudio"
                "bluetooth"
                "backlight"
              ]
              ++ lib.optionals batteryEnabled [
                "power-profiles-daemon"
                "battery"
              ]
              ++ [
                "idle_inhibitor"
                "tray"
              ];

              backlight = {
                format = "☼ {percent}%";
                on-update = "~/.local/bin/mako-brightness-notify";
              };

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

              "custom/system-menu" = {
                exec = "echo \"⚙️\"";
                interval = 3600;
                tooltip = false;
                on-click = "~/.config/rofi/rofi-system-menu.sh";
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
                format-alt = "{:%Y-%m-%d %H:%M:%S} ⏱️";
              };

              cpu.format = "{usage}% 🖥️";
              cpu.tooltip = false;

              memory.format = "{}% 🧠";

              pulseaudio = {
                format = "{volume}% {icon} {format_source}";
                format-bluetooth = "{volume}% {icon} {format_source}";
                format-bluetooth-muted = "✗🕨 {icon} {format_source}";
                format-icons = {
                  car = "🚗";
                  default = [
                    "🕨"
                    "🕩"
                    "🕪"
                  ];
                  handsfree = "🕻";
                  headphones = "🕻";
                  headset = "🕻";
                  phone = "☏";
                  portable = "☏";
                };
                format-muted = "✗🕨 {format_source}";
                format-source = "{volume}% 🎙";
                format-source-muted = "🎙✗";
                scroll-step = 5;
                on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
                on-click-right = "pavucontrol";
                on-update = "~/.local/bin/mako-volume-notify";
              };
            }
            // lib.optionalAttrs batteryEnabled {
              "power-profiles-daemon" = {
                "format" = "{icon}";
                "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
                "tooltip" = true;
                "format-icons" = {
                  "default" = "";
                  "performance" = "";
                  "balanced" = "";
                  "power-saver" = "";
                };
              };
              "battery" = {
                "states" = {
                  "good" = 95;
                  "warning" = 30;
                  "critical" = 15;
                };
                "format" = "{icon} {capacity}%";
                "format-charging" = " {capacity}%";
                "format-plugged" = " {capacity}%";
                "format-alt" = "{icon} {time}";
                "format-icons" = [
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };
            }
          )

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
              "cava"
              "mpris"
              "disk"
            ];

            cava = {
              # cava_config = "$XDG_CONFIG_HOME/cava/cava.conf";
              framerate = 30;
              autosens = 1;
              #sensitivity = 25;
              bars = 14;
              lower_cutoff_freq = 50;
              higher_cutoff_freq = 10000;
              method = "pulse";
              source = "auto";
              stereo = true;
              reverse = false;
              bar_delimiter = 0;
              monstercat = false;
              waves = false;
              noise_reduction = 0.77;
              input_delay = 2;
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
              actions = {
                "on-click-right" = "mode";
              };
            };

            mpris = {
              format = "{player_icon} {dynamic}";
              format-paused = "{status_icon} <i>{dynamic}</i>";
              dynamic-len = 30;
              player-icons = {
                default = "▶";
              };
              status-icons = {
                paused = "⏸";
              };
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

      systemd.user.services.waybar = {
        Unit = {
          Description = "Waybar status bar";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = config.my.systemd-sandboxing.user-desktop // {
          ExecStart = "${pkgs.waybar}/bin/waybar";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      systemd.user.services.nm-applet = {
        Unit = {
          Description = "NetworkManager Applet";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ] ++ lib.optional config.my.kwallet.enable "pam-kwallet-init.service";
          Wants = lib.optional config.my.kwallet.enable "pam-kwallet-init.service";
        };
        Service = config.my.systemd-sandboxing.user-desktop // {
          ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
