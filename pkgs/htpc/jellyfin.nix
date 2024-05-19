{ pkgs, lib,config, ... }:

{
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "media";
  };

  networking.firewall = {
    allowedTCPPorts = [
      8096 8920 # Web frontend
    ];
    allowedUDPPorts = [
      1900 7359 # Discovery
    ];
  };
}
