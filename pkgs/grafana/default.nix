{ config, pkgs, ... }: {
  # grafana configuration

  services.prometheus = {
    enable = false;
    port = 9001;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd"  ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "chrysalis";
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

  # services.nginx.virtualHosts."status.borgstad.dk" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #       proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
  #       proxyWebsockets = true;
  #   };
  # };
}
