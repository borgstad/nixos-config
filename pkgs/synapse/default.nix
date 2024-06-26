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

  services.coturn = {
    enable = true;
    lt-cred-mech = true;
    use-auth-secret = true;
    static-auth-secret = builtins.readFile config.age.secrets.matrix-synapse-secret.path;
    realm = "turn.borgstad.dk";
    no-tcp-relay = true;
    extraConfig = "
      cipher-list=\"HIGH\"
      no-loopback-peers
      no-multicast-peers
    ";
    secure-stun = true;
    cert = "/var/lib/acme/turn.borgstad.dk/fullchain.pem";
    pkey = "/var/lib/acme/turn.borgstad.dk/key.pem";
    min-port = 49152;
    max-port = 49999;
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      5349  # STUN tls
      5350  # STUN tls alt
      80    # http
      443   # https
      8448
    ];
    allowedUDPPortRanges = [
      { from=49152; to=49999; } # TURN relay
    ];
    allowedUDPPorts = [
      3478
    ];
  };


  # share certs with coturn and restart on renewal
  security.acme.certs = {
    "turn.borgstad.dk" = {
      group = "turnserver";
      postRun = "systemctl reload nginx.service; systemctl restart coturn.service";
    };
  };

  services.matrix-synapse = with config.services.coturn; with config.security.acme.certs."matrix.borgstad.dk"; {
    settings = {
      tls_certificate_path = config.security.acme.certs."matrix.borgstad.dk".directory + "/fullchain.pem";
      tls_private_key_path = config.security.acme.certs."matrix.borgstad.dk".directory + "/key.pem";
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
        "turns:turn.borgstad.dk:5349?transport=tcp" # TURNS URI
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
      # registration_shared_secret = config.services.coturn.static-auth-secret;
    };
    enable = true;
  };

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
    '';
  };
}
