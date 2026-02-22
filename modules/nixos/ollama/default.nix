{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.ollama.enable {
    environment.systemPackages = [
      (pkgs.llama-cpp.override {
        cudaSupport = true;
      })
    ];
  };
}
