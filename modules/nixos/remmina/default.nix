{ config, lib, pkgs, ... }:
let
  remmina-bleeding = pkgs.remmina.overrideAttrs (oldAttrs: {
    version = "master-unstable";
    
    src = pkgs.fetchFromGitLab {
      owner = "Remmina";
      repo = "Remmina";
      rev = "328d1747c2382ca09c1d18c84d332dd8c67d9ca5";
      sha256 = "sha256-BPay9/HV0XbxsqVCVmkzHM/nr+6o+fAmDIzm3CUx8Vk=";
    };
    
    # Optional: You might need to adjust build dependencies for bleeding edge
    # buildInputs = oldAttrs.buildInputs ++ [ /* additional deps if needed */ ];
    
    meta = oldAttrs.meta // {
      description = oldAttrs.meta.description + " (bleeding edge from master)";
    };
  });
in
{
  config = lib.mkIf config.my.remmina.enable {
    environment.systemPackages = [ remmina-bleeding ];
  };
}
