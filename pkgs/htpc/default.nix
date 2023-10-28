{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      ./deluge.nix
      ./jellyfin.nix
      ./prowlarr.nix
      ./radarr.nix
      ./sonarr.nix
      ./bazarr.nix
      ./users.nix
    ];

  users.groups.indolentdk.members = [ "nginx" ];
  #fileSystems."/funpool" =
  #  { device = "funpool";
  #    fsType = "zfs";
  #    options=[ "nofail" ];
  #  };
  #fileSystems."/funpool/house-scraper" =
  #  { device = "funpool/house-scraper";
  #    fsType = "zfs";
  #    options=[ "nofail" ];
  #  };
  #fileSystems."/funpool/ml" =
  #  { device = "funpool/ml";
  #    fsType = "zfs";
  #    options=[ "nofail" ];
  #  };
  #fileSystems."/funpool/open-sourdough" =
  #  { device = "funpool/open-sourdough";
  #    fsType = "zfs";
  #    options=[ "nofail" ];
  #  };
  #fileSystems."/funpool/series" =
  #  { device = "funpool/series";
  #    fsType = "zfs";
  #    options=[ "nofail" ];
  #  };

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
       proxyPass = "http://localhost:8096/";
     };
   };
  };
}
