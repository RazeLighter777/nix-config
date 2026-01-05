{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.ark.enable {
    environment.systemPackages = with pkgs.kdePackages; [
      ark
    ];
  };
}
