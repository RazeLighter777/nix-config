{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.battery.enable {
    services.power-profiles-daemon.enable = true;
  };
}
