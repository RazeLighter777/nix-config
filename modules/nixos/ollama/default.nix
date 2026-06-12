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
      (inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openssl ];
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DLLAMA_OPENSSL=ON" ];
      }))
    ];
  };
}
