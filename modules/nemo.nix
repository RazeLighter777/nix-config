{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        nemo-with-extensions
    ];
}