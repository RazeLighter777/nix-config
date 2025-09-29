{ pkgs, ... }:
{
  # Additional KDE / general desktop tools specific to KDE host.
  environment.systemPackages = with pkgs; [ pavucontrol ];
}
