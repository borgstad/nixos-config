{config, pkgs, lib, ...}:

{
  users.groups.borgstaddk.members = [ "nginx"  "matrix-synapse" ];
  users.groups.funborgstaddk.members = [ "nginx" ];

  security.acme.certs = {
    "borgstad.dk" = {
      group = "borgstaddk";
      postRun = "systemctl reload nginx.service";
    };
  };
  security.acme.certs = {
    "fun.borgstad.dk" = {
      group = "funborgstaddk";
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

    # virtualHosts."test.borgstad.dk".locations."/" = {
    #   return = "301 https://borgstad.dk";
    # };

    virtualHosts."borgstad.dk" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        root = "/var/www/test";
      };
    };

    virtualHosts."fun.borgstad.dk" = {
      forceSSL = true;
      enableACME = true;
      locations."/deluge" = {
        proxyPass = "http://localhost:8112/";
        extraConfig = ''
          proxy_set_header X-Deluge-Base "/deluge/";
          add_header X-Frame-Options SAMEORIGIN;
        '';
      };
    };
  };
}
