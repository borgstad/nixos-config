{config, pkgs, lib, ...}:

{
  users.groups.matrixborg.members = [ "nginx" "matrix-synapse" ];
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
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8448 ];
  security.acme = {
    acceptTerms = true;
    email = "aborgstad@gmail.com";
  };
  networking.firewall.allowedUDPPorts = [ 5349 5350 3478 3479];

  services.coturn = {
    enable = true;
    min-port = 49000;
    max-port = 50000;
    cli-password = "adslkjfhwiuhiuhiu345987adsfk";
    use-auth-secret = true;
    static-auth-secret = "I2QdtTZ1p8nI7CF4zo8UpbgNq9cTp79L6PxPAml8rrvUUw8yr9q6RzoPr10DGv5F";
    realm = "turn.matrix.borgstad.dk";
    no-tcp-relay = true;
    no-tls = true;
    no-dtls = true;
    extraConfig = ''
      user-quota=12
      total-quota=1200
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      allowed-peer-ip=192.168.191.127
    '';
  };

  services.matrix-synapse = {
    enable = true;
    server_name = "borgstad.dk";
    enable_metrics = true;
    enable_registration = true;
    public_baseurl = "https://matrix.borgstad.dk/";
    registration_shared_secret = "ZqthyiKPZYmqsjaixThzwXusKhljfiwsua5T4yNQyZ7TExyz7D2hk0v3Ib0dFSKL";
    tls_certificate_path = "/var/lib/acme/borgstad.dk/fullchain.pem";
    tls_private_key_path = "/var/lib/acme/borgstad.dk/key.pem";
    database_type = "psycopg2";
    database_args = {
      password = "synapse";
      user = "matrix-synapse";
      host = "localhost";
    };
    listeners = [
      { # federation
        bind_address = "";
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
        bind_address = "127.0.0.1";
        port = 8008;
        resources = [
          { compress = true; names = [ "client" ]; }
        ];
        tls = false;
        type = "http";
        x_forwarded = true;
      }
    ];

    turn_uris = [
      "turn:turn.matrix.borgstad.dk:3478?transport=udp"
      "turn:turn.matrix.borgstad.dk:3478?transport=tcp"
    ];
    turn_shared_secret = config.services.coturn.static-auth-secret;
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
