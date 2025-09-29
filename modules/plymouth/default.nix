{ config, lib, ... }:
let cfg = config.my.plymouth; in {
  options.my.plymouth.enable = lib.mkEnableOption "Enable Plymouth boot splash";
  config = lib.mkIf cfg.enable {
    boot.plymouth.enable = true;
  };
}
