{ config, lib, pkgs, ... }:

{
  networking = {
    useDHCP = false;
    hostId = "1cebebb1";
    hostName = "midgard";
  };
}
