{ pkgs, lib, ... }:
{
  services.ollama = {
    enable = true;
    loadModels = [
      "hf.co/unsloth/GLM-4.5-Air-GGUF:Q4_K_M"
    ];
    acceleration = "cuda";
  };
}
