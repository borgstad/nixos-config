{ config, pkgs, ... }: {
<<<<<<< HEAD
=======
  # grafana configuration

>>>>>>> 728e42f (other branch)
  services.prometheus = {
    enable = false;
    port = 9001;

    exporters = {
      node = {
        enable = true;
<<<<<<< HEAD
        enabledCollectors = [ "systemd" ];
=======
        enabledCollectors = [ "systemd"  ];
>>>>>>> 728e42f (other branch)
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
<<<<<<< HEAD
        job_name = "scraper";
=======
        job_name = "chrysalis";
>>>>>>> 728e42f (other branch)
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.borgstad";
      http_port = 2342;
      http_addr = "127.0.0.1";
    };
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
    };
  };

<<<<<<< HEAD
  # services.nginx.virtualHosts."monitoring.borgstad.dk" = {
  #  enableACME = true;
  #  forceSSL = true;
  #  locations."/" = {
  #      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
  #      proxyWebsockets = true;
  #  };
=======
  # services.nginx.virtualHosts."status.borgstad.dk" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #       proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
  #       proxyWebsockets = true;
  #   };
>>>>>>> 728e42f (other branch)
  # };
}
