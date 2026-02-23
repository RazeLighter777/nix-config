{
  config,
  pkgs,
  lib,
  ...
}:
let 
  cfg = config.my.qflipper;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qFlipper
    ];
    # Udev rules for Flipper Zero access
    services.udev.extraRules = ''
      # Flipper Zero serial port
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess", GROUP="dialout"
      # Flipper Zero DFU
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess", GROUP="dialout"
    '';
  };
}
