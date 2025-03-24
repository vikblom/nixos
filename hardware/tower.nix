{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/bc368f7b-9199-41a7-9e44-f60d94fb342b";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/A6BF-EF46";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.supportedFilesystems = [ "ntfs" ];

  # Additional permanent drives.
  # fileSystems."/run/media/samsung-linux" = {
  #   device = "/dev/disk/by-uuid/4acd065b-2d01-4513-8796-ab01d71b1400";
  #   fsType = "auto";
  #   options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
  # };
  # fileSystems."/run/media/samsung-windows" = {
  #   device = "/dev/disk/by-uuid/264E526D4E523631";
  #   fsType = "auto";
  #   options = [ "ro" "uid=1000" "gid=100" "dmask=027" "fmask=137" ];
  # };

}
