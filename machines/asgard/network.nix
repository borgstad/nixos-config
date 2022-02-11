{ config, lib, pkgs, ... }:

{
  networking = {
    useDHCP = false;
    hostId = "98e01021";
    hostName = "asgard";
    # interfaces = {
    #   wlp3s0.useDHCP = true;
    #   wwp0s20u4i6.useDHCP = true;
    # };
    # wireless = {
    #   enable = true;
    #   networks = {
    #     dlink-5808-5GHz = {
    #       psk = "wdqty59917";
    #     };
    #   };
    # };
  };
}

