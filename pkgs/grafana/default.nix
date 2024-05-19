{ config, pkgs, ... }: {
  #services.prometheus = {
  #  enable = false;
  #  port = 9001;

  #  exporters = {
  #    node = {
  #      enable = true;
  #      enabledCollectors = [ "systemd"  ];
  #      job_name = "scraper";
  #      static_configs = [{
  #        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
  #      }];
  #    };
  #};

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
}
