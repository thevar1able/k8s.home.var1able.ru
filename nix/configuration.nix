# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.cpu.intel.updateMicrocode = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Moscow";

  networking = {
    hostName = "opti";
    enableIPv6 = false;
    firewall = {
      allowedTCPPorts = [ 6443 ];
    };
  };
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;

  services.openssh.enable = true;

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/mnt/sanic" = {
      device = "/dev/disk/by-label/sanic";
      fsType = "btrfs";
    };
    "/mnt/chonker" = {
      device = "/dev/disk/by-label/chonker";
      fsType = "btrfs";
    };

    "/mnt/kubernetes-pvs/sanic/test-pv" = {
      device = "/mnt/sanic/test-pv";
      options = [ "bind" ];
    };

    "/mnt/kubernetes-pvs/chonker/torrents" = {
      device = "/mnt/chonker/torrents";
      options = [ "bind" ];
    };
  };

  users.users = {
      thevar1able = {
        isNormalUser = true;
        extraGroups = [ "wheel" "sudo" ];
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyjtLr5GoHo3VqsMM6hH37sUWrZL223dLUckwuVvt1vC2boql6kUw3OXwkwlshpygZejSP6t+OPyOgteijX2KBLIsjKbDZDncaJFZKjHTtfEbmG0rugJ38EFPFV7oUgNV6aTErM3L5nWXLEahUgO3HPc+BhQj0psdNw9wHgmLBToxdABIp4AM/a4ehOjQw3c7W8tdjzwx3vlf3npGHjD5O9ClPi+I7KXKXRI3AoHW4gy8AO+jxtsdacw1b5fTLyiutK3jaKb3BpERVyhG5w+h3NLPI9K4pjTMFOqb3rOG4w85psRClB+svt8GAM+mDQ+4U7opkDTaAj1bEXLSKu5dx thevar1able@var1able-laptop" ];
      };
  };

  services.k3s = {
    enable = true;
    extraFlags = "--tls-san k8s.home.var1able.ru";
  };

  system.stateVersion = "21.05"; # Did you read the comment?
}

