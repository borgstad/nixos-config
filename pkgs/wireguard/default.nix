{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.14.0.2/16" ];
      listenPort = 51820;
      privateKeyFile = "UF9aRgjJtMRAQ9BewvXi3o6/2nyMgs7di+iEk77b8F4=";
      peers = [
        {
          publicKey = "peDjRPEdHHmo0hGootZ9f+MQCEXmziFkLhMTl2PeXRM=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "dk-cph.prod.surfshark.com:51820";
        }
      ];
    };
  };
}
