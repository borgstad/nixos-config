{ config, pkgs, lib, ... }:

{
  services.sonarr = {
    enable = true;
    user = "radarr";
    group = "media";
    openFirewall = true;
   };
}
