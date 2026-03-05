{ inputs, self, ... }:
let
  hardware = inputs.nixos-hardware.nixosModules;
  nixos = self.modules.nixos;
in
{
  base = {
    hostPlatform = "x86_64-linux";
    stateVersion = "25.11"; # WARN: do not change this value
  };

  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      hardware.common-cpu-intel
      hardware.common-gpu-intel-comet-lake
      hardware.common-pc-ssd
      inputs.disko.nixosModules.disko
      nixos.base
      nixos.desktop
      nixos.gnome
      self.nixosModules.desktop
    ];
  };

  flake.nixosModules.desktop = _: {
    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ "kvm-intel" ];
    };

    networking.hostName = "desktop";

    services.flatpak.enable = true;

    users.users.ethan = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
