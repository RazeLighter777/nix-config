{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.pcmanfm.enable {
    environment.systemPackages = [
      pkgs.pcmanfm
      pkgs.lxmenu-data
      pkgs.shared-mime-info
    ];
  };
}
