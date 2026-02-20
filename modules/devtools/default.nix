{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.devtools.enable {
    environment.systemPackages = with pkgs; [
      b4
      usbutils
      tokei
      btop
      iotop
      lshw
      dnsutils
      valgrind
      talosctl
      terraform
      mutt
    ];
  };
}
