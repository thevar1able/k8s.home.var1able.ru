{ config, pkgs, ... }:

{
  services.miniupnpd = {
    enable = true;
    externalInterface = "enp2s0";
    internalIPs = [ "enp2s0" ];
  };
}
