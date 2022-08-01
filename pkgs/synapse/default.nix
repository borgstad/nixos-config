{config, pkgs, lib, ...}:

{
  users.groups.matrixborg.members = [ "nginx" "matrix-synapse" ];
  users.groups.turnserver.members = [ "nginx" "turnserver" "matrix-synapse" ];

  security.acme.certs = {
    "matrix.borgstad.dk" = {
      group = "matrixborg";
      postRun = "systemctl reload nginx.service; systemctl restart matrix-synapse.service";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts."matrix.borgstad.dk" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8008";
      };
    };
    virtualHosts = {
      "turn.borgstad.dk" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:3478";
        };
      };
    };

  };

  security.acme = {
    acceptTerms = true;
  };

  services.coturn = with config.security.acme.certs."turn.borgstad.dk"; {
    enable = true;
    use-auth-secret = false;
    static-auth-secret = builtins.readFile ./auth-secret;
    realm = "turn.borgstad.dk";
    relay-ips = [
      "192.168.0.140"
    ];
    cli-password = builtins.readFile ./cli-password;
    no-tcp-relay = true;
    extraConfig = "
      cipher-list=\"HIGH\"
    ";
    secure-stun = true;
    cert = config.security.acme.certs."turn.borgstad.dk".directory + "/fullchain.pem";
    pkey = config.security.acme.certs."turn.borgstad.dk".directory + "/key.pem";
    min-port = 49000;
    max-port = 50000;
  };

  networking.firewall = with config.services.coturn; {
    enable = true;
    allowPing = false;
    allowedUDPPorts = [ 3478 ];
    allowedTCPPorts = [
      3478  # STUN tls
      80    # http
      443   # https
    ];
    allowedUDPPortRanges = [
      { from=min-port; to=max-port; } # TURN relay
    ];
  };

  # share certs with coturn and restart on renewal
  security.acme.certs = {
    "turn.borgstad.dk" = {
      group = "turnserver";
      postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
    };
  };

  services.matrix-synapse = with config.services.coturn; with config.security.acme.certs."borgstad.dk"; {
    settings = {
      tls_certificate_path = config.security.acme.certs."borgstad.dk".directory + "/fullchain.pem";
      tls_private_key_path = config.security.acme.certs."borgstad.dk".directory + "/key.pem";
      server_name = "borgstad.dk";

      listeners = [
        { # federation
          bind_addresses = [ "" ];
          port = 8448;
          resources = [
            { compress = true; names = [ "client" ]; }
            { compress = false; names = [ "federation" ]; }
          ];
          tls = true;
          type = "http";
          x_forwarded = false;
        }
        { # client
          bind_addresses = [ "127.0.0.1" ];
          port = 8008;
          resources = [
            { compress = true; names = [ "client" ]; }
          ];
          tls = false;
          type = "http";
          x_forwarded = true;
        }
      ];

      turn_shared_secret = config.services.coturn.static-auth-secret;
      turn_uris = [
        "turn:turn.borgstad.dk:3478?transport=udp"
        "turn:turn.borgstad.dk:3478?transport=tcp"
      ];

      enable_metrics = true;
      database_type = "psycopg2";
      database_args = {
        password = "synapse";
        user = "matrix-synapse";
        host = "localhost";
      };
      enable_registration = false;
      public_baseurl = "https://matrix.borgstad.dk/";
      registration_shared_secret = config.services.coturn.static-auth-secret;
    };
    enable = true;
  };

  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
    '';
  };
}
