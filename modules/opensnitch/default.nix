{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.opensnitch.enable {
    services.opensnitch.enable = true;
    
    environment.systemPackages = with pkgs; [
      opensnitch
      opensnitch-ui
      config.boot.kernelPackages.opensnitch-ebpf
    ];
  };
}
