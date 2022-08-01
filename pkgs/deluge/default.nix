{ config, pkgs, ... }:

{
  services.deluge = {
    enable = true;
    web.enable = true;
    web.openFirewall = true;
    openFirewall = true;
    declarative = true;
    config = {
      download_location = "/plex/videos";
      sequential_download = true;
      allow_remote = true;
      max_upload_speed = "500.0";
      daemon_port = 58846;
      listen_ports = [ 6881 6889 ];
    };
    authFile = builtins.toString ./authfile;
    user = "deluge";
    group = "plex";
  };
  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      6881
      6889
      58846
    ];
  };
}
