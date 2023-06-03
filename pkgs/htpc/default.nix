{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      ./deluge.nix
      ./users.nix
      ./jellyfin.nix
    ];

  users.groups.indolentdk.members = [ "nginx" ];
  fileSystems."/tank" =
    { device = "tank";
      fsType = "zfs";
      options=[ "nofail" ];
    };
  fileSystems."/tank/house-scraper" =
    { device = "tank/house-scraper";
      fsType = "zfs";
      options=[ "nofail" ];
    };
  fileSystems."/tank/ml" =
    { device = "tank/ml";
      fsType = "zfs";
      options=[ "nofail" ];
    };
  fileSystems."/tank/open-sourdough" =
    { device = "tank/open-sourdough";
      fsType = "zfs";
      options=[ "nofail" ];
    };
  fileSystems."/tank/series" =
    { device = "tank/series";
      fsType = "zfs";
      options=[ "nofail" ];
    };

  security.acme.certs = {
   "indolent.dk" = {
     group = "indolentdk";
     postRun = "systemctl reload nginx.service";
   };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme = {
   acceptTerms = true;
   defaults.email = "aborgstad@gmail.com";
  };

  services.nginx = {
   enable = true;
   recommendedGzipSettings = true;
   recommendedOptimisation = true;
   recommendedTlsSettings = true;

   virtualHosts."indolent.dk" = {
     forceSSL = true;
     enableACME = true;
     locations."/" = {
       proxyPass = "http://localhost:8112/";
       extraConfig = ''
         proxy_set_header X-Deluge-Base "/deluge/";
         add_header X-Frame-Options SAMEORIGIN;
       '';
     };
   };
  };
}
