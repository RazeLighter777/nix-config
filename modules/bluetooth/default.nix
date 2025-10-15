{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.bluetooth;
in
{
  options.my.bluetooth.enable = lib.mkEnableOption "Enable system Bluetooth stack and tools";
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
    ];
  };
}
