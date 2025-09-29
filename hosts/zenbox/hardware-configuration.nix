{ ... }: import ../../modules/hardware-configuration.nix
{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

	boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
	boot.initrd.kernelModules = [ ];
	boot.kernelModules = [ "kvm-amd" ];
	boot.extraModulePackages = [ ];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/a082b4a6-da76-4dbc-b1ee-3e7d03d13f5d";
		fsType = "xfs";
	};

	boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/04e00f6c-6043-442b-b400-6a5f6ecb4859";

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/EEB8-9F14";
		fsType = "vfat";
		options = [ "fmask=0077" "dmask=0077" ];
	};

	swapDevices = [ ];

	networking.useDHCP = lib.mkDefault true;
	hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

