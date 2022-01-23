# # { config, pkgs, ... }:

# # {
# #   services.nginx.enable = true;
# #   services.nginx.virtualHosts."localhost" = {
# #     addSSL = true;
# #     enableACME = true;
# #     root = "/var/www/localhost";
# #   };
# # } 
# { config, pkgs, ... }:

# {
#   services.nginx.enable = true;
  
#   services.nginx.virtualHosts."localhost" = {
#     locations."/"= {
#       root = "/home/ymir/www";
#     };
#   };
# }
  
{config, pkgs, lib, ...}: {
  # enable coturn
  services.coturn = rec {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = 49000;
    max-port = 50000;
    use-auth-secret = true;
    static-auth-secret = "will be world readable for local users :(";
    realm = "turn.example.com";
    cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
    pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
    extraConfig = ''
      # for debugging
      verbose
      # ban private IP ranges
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      denied-peer-ip=::1
      denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
      denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
      denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
      denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    '';
  };
  # open the firewall
  networking.firewall = {
    interfaces.enp2s0 = let
      range = with config.services.coturn; [ {
      from = min-port;
      to = max-port;
    } ];
    in
    {
      allowedUDPPortRanges = range;
      allowedUDPPorts = [ 3478 ];
      allowedTCPPortRanges = range;
      allowedTCPPorts = [ 3478 ];
    };
  };
  # get a certificate
  security.acme.certs.${config.services.coturn.realm} = {
    /* insert here the right configuration to obtain a certificate */
    postRun = "systemctl restart coturn.service";
    group = "turnserver";
  };
  # configure synapse to point users to coturn
  services.matrix-synapse = with config.services.coturn; {
    turn_uris = ["turn:${realm}:3478?transport=udp" "turn:${realm}:3478?transport=tcp"];
    turn_shared_secret = static-auth-secret;
    turn_user_lifetime = "1h";

    
    enable = true;
    server_name = "localhost";
    registration_shared_secret = "secret";
    public_baseurl = "https://localhost/";
    tls_certificate_path = "/var/lib/acme/localhost/fullchain.pem";
    tls_private_key_path = "/var/lib/acme/localhost/key.pem";
    database_type = "psycopg2";
    database_args = {
      database = "matrix-synapse";
    };
    listeners = [
      { # federation
        bind_address = "";
        port = 8448;
        resources = [
          { compress = true; names = [ "client" "webclient" ]; }
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
          { compress = true; names = [ "client" "webclient" ]; }
        ];
        tls = false;
        type = "http";
        x_forwarded = true;
      }
    ];
    extraConfig = ''
      max_upload_size: "100M"
    '';
  };


  # web client proxy and setup certs
  services.nginx = {
    enable = true;
    virtualHosts = {
      "localhost" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8008";
        };
      };
    };
  };

  # share certs with matrix-synapse and restart on renewal
  security.acme.certs = {
    "localhost" = {
      group = "matrix-synapse";
      allowKeysForGroup = true;
      postRun = "systemctl reload nginx.service; systemctl restart matrix-synapse.service";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      8448  # Matrix federation
      80    # http
      443   # https
    ];
  };
}
