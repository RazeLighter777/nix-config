{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.my.ollama.enable {
    environment.systemPackages = [
      inputs.llama-cpp.packages.${pkgs.system}.cuda
    ];
  };
}
