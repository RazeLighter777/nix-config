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
    environment.systemPackages = [
    ];
    users.users."${config.my.user.name}".extraGroups = [
      "scanner"
      "lp"
    ];
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        epson-escpr2
        epson-escpr
      ];
    };
  };
}
