{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball { url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz"; sha256 = "12246mk1xf1bmak1n36yfnr4b0vpcwlp6q66dgvz8ip8p27pfcw2";};
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];
  home-manager.users.justin = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;

        settings = {
          "extensions.autoDisableScopes" = 0;

          "browser.search.defaultenginename" = "Google";
          "browser.search.selectedEngine" = "Google";
          "browser.urlbar.placeholderName" = "Google";
          "browser.search.region" = "US";

          "browser.uidensity" = 1;
          "browser.search.openintab" = true;
          "xpinstall.signatures.required" = false;

          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;

          "extensions.pocket.enabled" = false;

          "places.history.enabled" = false;
          "browser.sessionstore.resume_from_crash" = false;
          "browser.sessionstore.max_tabs_undo" = 0;

        };
      };
    };
    programs.home-manager.enable = true;
    programs.git = {
      enable = true;
      userName = "RazeLighter777";
      userEmail = "gorgonballs@proton.me";
    }; 
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
    wayland.windowManager.hyprland = {
      # Whether to enable Hyprland wayland compositor
      enable = true;
      # The hyprland package to use
      package = pkgs.hyprland;
      # Whether to enable XWayland
      xwayland.enable = true;
    };
    programs.wofi.enable = true;
    wayland.windowManager.hyprland.settings = {

      "$mod" = "SUPER";
      exec-once = [
        "nm-applet"
        "wayvnc"
      ];
      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bind = [
        "CTRL ALT, T, exec, kitty"
	      "CTRL ALT, C, exec, hyprctl reload"
	      "$mod, D, exec, wofi --show drun --prompt 'Search...'"
        "$mod, L, exec, hyprlock"
        # Hyprland built-in keybinds from JaKooLit (excluding .sh and unknown programs)
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
        # Resize windows
        "$mod SHIFT, left, resizeactive,-50 0"
        "$mod SHIFT, right, resizeactive,50 0"
        "$mod SHIFT, up, resizeactive,0 -50"
        "$mod SHIFT, down, resizeactive,0 50"
        # Move windows
        "$mod CTRL, left, movewindow, l"
        "$mod CTRL, right, movewindow, r"
        "$mod CTRL, up, movewindow, u"
        "$mod CTRL, down, movewindow, d"
        # Swap windows
        "$mod ALT, left, swapwindow, l"
        "$mod ALT, right, swapwindow, r"
        "$mod ALT, up, swapwindow, u"
        "$mod ALT, down, swapwindow, d"
        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Workspaces
        "$mod, tab, workspace, m+1"
        "$mod SHIFT, tab, workspace, m-1"
        "$mod SHIFT, U, movetoworkspace, special"
        "$mod, U, togglespecialworkspace,"
        # Workspace switching (mainMod + [0-9])
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
        # Move active window and follow to workspace (mainMod + SHIFT [0-9])
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
        # Move active window to a workspace silently (mainMod + CTRL [0-9])
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
        # Scroll through workspaces
        "$mod, period, workspace, e+1"
        "$mod, comma, workspace, e-1"
      ];
    };
  };
}
