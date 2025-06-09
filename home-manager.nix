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
    programs.firefox.enable = true;
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

    wayland.windowManager.hyprland.settings = {
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      "$mod" = "SUPER";

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
  };
}
