{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.customKernel;
  linuxNextSrc = inputs.linux-next;
  linuxNextMakeVars =
    let
      lines = lib.splitString "\n" (builtins.readFile "${linuxNextSrc}/Makefile");
      parseVarLine = line:
        let
          match = builtins.match "([A-Z0-9_]+)[[:space:]]*=[[:space:]]*(.*)" line;
        in
        if match == null then
          null
        else
          {
            name = builtins.elemAt match 0;
            value = builtins.elemAt match 1;
          };
      vars = lib.filter (v: v != null) (map parseVarLine lines);
    in
    builtins.listToAttrs vars;
  linuxNextLocalVersion =
    let
      suffixPath = "${linuxNextSrc}/localversion-next";
    in
    if builtins.pathExists suffixPath then
      lib.removeSuffix "\n" (builtins.readFile suffixPath)
    else
      "";
  linuxNextKernel =
    let
      linux-next-pkg =
        { buildLinux, ... }@args:
        buildLinux (
          args
          // rec {
            src = linuxNextSrc;
            version = "${linuxNextMakeVars.VERSION}.${linuxNextMakeVars.PATCHLEVEL}.${linuxNextMakeVars.SUBLEVEL}${linuxNextLocalVersion}";
            modDirVersion = version;
            kernelPatches = [ ];

            # Use defconfig as base, then override with our options.
            autoModules = true;
            ignoreConfigErrors = true;

            extraMeta.branch = "master";
          }
          // (args.argsOverride or { })
        );
    in
    pkgs.callPackage linux-next-pkg { };
  linuxNextPackages = (pkgs.linuxPackagesFor linuxNextKernel).extend (
    _: _: {
      # cpupower from linux-next currently fails to apply randstruct patch in nixpkgs.
      # Reuse cpupower from the default package set so cpuFreqGovernor service can build.
      cpupower = pkgs.linuxPackages.cpupower;
    }
  );
in
{
  config = lib.mkIf cfg.enable {
    boot.kernelPackages = lib.mkForce (lib.recurseIntoAttrs linuxNextPackages);
  };
}
