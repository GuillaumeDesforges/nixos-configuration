{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Graphics & NVIDIA drivers
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia.open = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  warnings = [ "Reminder: NVIDIA driver had been set to beta: ${config.hardware.nvidia.package}" ];
  hardware.nvidia-container-toolkit.enable = true;
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f71dd744-1d6c-4e4d-a4e3-be0470d62ced";
    fsType = "ext4";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/171e9df3-f161-44ba-8e3f-5c988bdbb18a";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6330-C047";
    fsType = "vfat";
  };
  swapDevices = [ { device = "/dev/disk/by-uuid/19119300-e100-4843-bf89-8a47cc6352bc"; } ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;
}
