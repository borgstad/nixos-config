{ config, lib, pkgs, modulesPath, ... }:
{
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.14.0.2/16" ];
      privateKey = "yEpCjXp/OaazWAYctkJUPy3F60RLedXuaN22FeGaWnc=";
      listenPort = 51820;
      peers = [{
        publicKey = "peDjRPEdHHmo0hGootZ9f+MQCEXmziFkLhMTl2PeXRM=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "dk-cph.prod.surfshark.com:51820";
      }];
    };
  };
  networking.nameservers = [ "162.252.172.57" "149.154.159.92" ];
}
