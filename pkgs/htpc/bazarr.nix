{ config, pkgs, lib, ... }:

{
  services.bazarr = {
    enable = true;
    user = "radarr";
    group = "media";
    openFirewall = true;
   };
}
