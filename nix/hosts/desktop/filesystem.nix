{ ... }:
{
  flake.nixosModules.desktop = _: {
    disko.devices.disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {

          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              device = "/dev/disk/by-label/NIXBOOT";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              device = "/dev/disk/by-label/NIXROOT";
              mountpoint = "/";
            };
          };
        };
      };
    };

    swapDevices = [ { device = "/.swapfile"; } ];
  };
}
