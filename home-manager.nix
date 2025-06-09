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
    programs.home-manager.enable = true;
    programs.git = {
      enable = true;
      userName = "RazeLighter777";
      userEmail = "gorgonballs@proton.me";
    }; 
    programs.kitty.enable = true;
    programs.hyprland.withUWSM = true;
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      bind =
      [
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
