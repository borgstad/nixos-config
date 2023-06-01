{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      ./deluge.nix
      ./users.nix
      ./jellyfin.nix
    ];

  users.groups.indolentdk.members = [ "nginx" ];

  #security.acme.certs = {
  #  "indolent.dk" = {
  #    group = "indolentdk";
  #    postRun = "systemctl reload nginx.service";
  #  };
  #};

  #networking.firewall.allowedTCPPorts = [ 80 443 ];
  #security.acme = {
  #  acceptTerms = true;
  #  defaults.email = "aborgstad@gmail.com";
  #};

  #services.nginx = {
  #  enable = true;
  #  recommendedGzipSettings = true;
  #  recommendedOptimisation = true;
  #  recommendedTlsSettings = true;

  #  virtualHosts."indolent.dk" = {
  #    forceSSL = true;
  #    enableACME = true;
  #    locations."/" = {
  #      proxyPass = "http://localhost:8112/";
  #      extraConfig = ''
  #        proxy_set_header X-Deluge-Base "/deluge/";
  #        add_header X-Frame-Options SAMEORIGIN;
  #      '';
  #    };
  #  };
  #};
}
