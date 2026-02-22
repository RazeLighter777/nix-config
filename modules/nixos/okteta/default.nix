{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.okteta.enable {
    environment.systemPackages = with pkgs; [
      okteta
    ];
  };
}
