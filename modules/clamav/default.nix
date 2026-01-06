{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.clamav.enable {
    environment.systemPackages = with pkgs; [
      clamav
      clamtk
    ];

    services.clamav.daemon.enable = true;
    services.clamav.updater.enable = true;

    services.clamav.daemon.settings = {
      OnAccessPrevention = true;
      OnAccessIncludePath = "${config.my.user.homeDir}/Downloads";
    };
  };
}
