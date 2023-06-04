{ config, pkgs, lib, ... }:

{
  services.prowlarr = {
    enable = true;
    openFirewall = true;
   };
}
