{ config, pkgs, ... }:

{
  services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "gnome-session";
  # services.xrdp.openFirewall = true;
}
