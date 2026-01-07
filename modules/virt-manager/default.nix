{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.virt-manager.enable {
    environment.systemPackages = with pkgs; [
      qemu
      virt-manager
    ];
    
    # Enable libvirtd service for virtual machine management
    virtualisation.libvirtd.enable = true;
    
    # Add user to libvirtd group
    users.users.${config.my.user.name}.extraGroups = [ "libvirtd" ];
  };
}
