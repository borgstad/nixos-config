{ config, lib, pkgs, ... }:

{
  networking = {
    useDHCP = false;
    hostId = "1cd1bb5c";
    hostName = "gimle";
  };
}
