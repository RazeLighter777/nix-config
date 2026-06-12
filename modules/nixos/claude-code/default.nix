{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.claude-code.enable {
    nixpkgs.config.allowUnfree = lib.mkDefault true;
    environment.systemPackages = [ pkgs.claude-code ];
  };
}
