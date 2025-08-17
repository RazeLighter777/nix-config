{ pkgs, lib, ... }:
let
  customOllama = pkgs.ollama-cuda.overrideAttrs (old: {
    pname = "ollama";
    version = "v0.11.5-rc2";
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v0.11.5-rc2";
      sha256 = "sha256-SlaDsu001TUW+t9WRp7LqxUSQSGDF1Lqu9M1bgILoX4=";
    };
  });
in
{
  services.ollama = {
    enable = true;
    package = customOllama;
    loadModels = [
      # "gpt-oss:120b"
    ];
    acceleration = "cuda";
  };
  environment.systemPackages = with pkgs; [
    customOllama
  ];
}
