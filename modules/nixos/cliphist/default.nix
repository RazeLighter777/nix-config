{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.cliphist.enable {
    environment.systemPackages = with pkgs; [
      cliphist
      wl-clip-persist
      wl-clipboard
    ];
  };
}