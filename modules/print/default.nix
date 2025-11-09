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
  options.my.print.enable = lib.mkEnableOption "Enable printing";
  config = lib.mkIf cfg.enable {
	services.printing.enable = true;
  };
}
