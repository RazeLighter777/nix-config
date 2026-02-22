{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.virt-manager.enable {
    environment.systemPackages = with pkgs; [
      spice-gtk
      qemu
      virt-manager
    ];
    
    # Enable libvirtd service for virtual machine management
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    # Add user to libvirtd group
    users.users.${config.my.user.name}.extraGroups = [ "libvirtd" ];
  };
}
