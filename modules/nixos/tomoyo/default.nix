{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.tomoyo;

  defaultModules = inputs.tomoyo-experiments.lib.policies.defaultModules;
in
{
  imports = [
    inputs.tomoyo-tools.nixosModules.default
    inputs.tomoyo-experiments.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.tomoyo-tools.overlays.default
      inputs.tomoyo-experiments.overlays.default
    ];

    security.tomoyo.enable = true;
    security.tomoyo.services.tomoyod.enable = true;
    security.tomoyo.services.tomoyoAuditd.enable = lib.mkDefault true;

    security.tomoyo.policyModules = lib.mkBefore defaultModules;

    security.tomoyo.referencePolicy = {
      enable = true;
      defaultProfile = "2";
    };

    environment.systemPackages = lib.mkAfter [
      pkgs.tomoyo-tools
      pkgs.tomoyod
      pkgs.tomoyoctl
    ];
  };
}
