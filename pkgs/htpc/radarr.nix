{ config, pkgs, lib, ... }:

{
  services.radarr = {
    enable = true;
    user = "radarr";
    group = "media";
    openFirewall = true;
   };
}
