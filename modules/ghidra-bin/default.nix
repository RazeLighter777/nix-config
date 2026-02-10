{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.ghidra-bin.enable {
    environment.systemPackages = with pkgs; [
      ghidra-bin
    ];
  };
}
