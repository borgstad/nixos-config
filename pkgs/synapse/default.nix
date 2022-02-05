{config, pkgs, lib, ...}:
# {
#  services.nginx = {
#    enable = true;
#    virtualHosts = {

#      ## virtual host for Syapse
#      "matrix.borgstad.dk" = {
#        ## for force redirecting HTTP to HTTPS
#        forceSSL = true;
#        ## this setting takes care of all LetsEncrypt business
#        enableACME = true;
#        locations."/" = { 
#         proxyPass = "http://localhost:8008";
#        };
#      };
#    };

#    ## other nginx specific best practices
#    recommendedGzipSettings = true;
#    recommendedOptimisation = true;
#    recommendedTlsSettings = true;
#  };
# }
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."localhost" = {
    addSSL = false;
    enableACME = false;
    root = "/var/www/test";
  };

}

  
