{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.print;
in
{
  options.my.qflipper.enable = lib.mkEnableOption "Enable qFlipper";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qFlipper
    ];
  };
}
