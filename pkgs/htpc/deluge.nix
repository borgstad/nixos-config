{ config, pkgs, lib, ... }:

{
  imports = [ ../../secrets ];

  services.deluge = {
   enable = true;
   web = {
    enable = true;
     openFirewall = true;
     port = 8112;
   };
   openFirewall = true;
   declarative = true;
   config = {
     download_location = "/tank/complete";
     sequential_download = true;
     allow_remote = true;
     max_upload_speed = "500.0";
     daemon_port = 58846;
     listen_ports = [ 6881 6889 ];
   };
   authFile = config.age.secrets.deluge-pass.path;
   user = "deluge";
   group = "media";
   };
}
