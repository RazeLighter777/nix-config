{ config, lib, ... }:
let cfg = config.my.pipewire; in {
  options.my.pipewire.enable = lib.mkEnableOption "Enable PipeWire audio (with ALSA + PulseAudio compatibility)";
  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
