{ config, pkgs, ... }:

{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "8056c2e21c3b4622" ];
  };
}
