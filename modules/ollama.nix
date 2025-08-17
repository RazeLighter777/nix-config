{ pkgs, lib, ... }:
let
  customOllama = pkgs.ollama-cuda.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "d925b5350c75a66e7830e00f53b243084395821f";
      sha256 = "sha256-/uo35G5aWyU/TBPeaCA1muw2hZgOokONW29Ox9vZgg4=";
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
