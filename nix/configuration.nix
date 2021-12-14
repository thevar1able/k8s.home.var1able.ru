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
      allowedTCPPorts = [ 6443 6881 2049 111 2049 4000 4001 4002 20048 32400 32080 32443 10250 ];
      allowedUDPPorts = [ 6881 111 2049 4000 4001 4002 20048 ];
    };    
  };
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/mnt/sanic" = {
      device = "/dev/disk/by-label/sanic";
      fsType = "btrfs";
    };

    "/srv/nfs/kubernetes-pvs/sanic" = {
      device = "/mnt/sanic";
      options = [ "bind" ];
    };
  };

  users.users = {
      thevar1able = {
        isNormalUser = true;
        extraGroups = [ "wheel" "sudo" ];
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhwryvaSBXLv6DnPAvyN4j98LvnWGz8vxknmfc6ZiJV var1able@var1able.ru" ];
      };
  };

  services.k3s = {
    enable = true;
    extraFlags = "--tls-san k8s.home.var1able.ru --disable traefik";
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs/kubernetes-pvs/sanic 127.0.0.0/8(rw,sync,all_squash,no_subtree_check,anonuid=1000,anongid=100)
    '';
    createMountPoints = true;
  };

  system.stateVersion = "21.05"; # Did you read the comment?
}

