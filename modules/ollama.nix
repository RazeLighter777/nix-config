{ pkgs, lib, ... }:
let
  customOllama = pkgs.ollama-cuda.overrideAttrs (old: {
    pname = "ollama-cuda";
    version = "v0.11.4";
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v0.11.4";
      sha256 = "sha256-joIA/rH8j+SJH5EVMr6iqKLve6bkntPQM43KCN9JTZ8=";
    };
    vendorHash = "sha256-SlaDsu001TUW+t9WRp7LqxUSQSGDF1Lqu9M1bgILoX4=";
  });
  inherit (lib) cmakeBool cmakeFeature;
  customLlamaCpp =
    (pkgs.llama-cpp.override {
      cudaSupport = true;
      rocmSupport = false;
      metalSupport = false;
    }).overrideAttrs
      (old: {
        pname = "llama-cpp";
        version = "b6191";
        src = pkgs.fetchFromGitHub {
          owner = "ggerganov";
          repo = "llama.cpp";
          rev = "b6191";
          sha256 = "sha256-niUHCN/CJgUyX9TjwC72luxf9mjNaNNeXkT3jNNFg14=";
        };
        cmakeFlags = old.cmakeFlags ++ [
          (cmakeBool "GGML_AVX2" true)
          (cmakeFeature "CMAKE_C_FLAGS" "-fpermissive")
        ];
      });
in
{
  services.ollama = {
    enable = true;
    package = customOllama;
    loadModels = [
      "gpt-oss:120b"
    ];
    acceleration = "cuda";
  };
  environment.systemPackages = [
    customOllama
    customLlamaCpp
  ];
}
