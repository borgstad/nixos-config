{ config, lib, pkgs, modulesPath, ... }:
{
  networking.firewall.extraCommands = let
  iptables = "${pkgs.iptables}/bin/iptables";
  mark = "0xca6c"; # Custom mark for Deluge traffic
  delugeUID = "83"; # Replace with the actual UID of the Deluge user
  in ''
     ${iptables} -t mangle -A OUTPUT -p tcp -m owner --uid-owner ${delugeUID} -j MARK --set-mark ${mark}
     ${iptables} -t mangle -A OUTPUT -p udp -m owner --uid-owner ${delugeUID} -j MARK --set-mark ${mark}
  '';
  networking.firewall.extraStopCommands = let
    mark = "0xca6c";
    delugeUID = "83"; # Replace with the actual UID of the Deluge user
    iptables = "${pkgs.iptables}/bin/iptables";
  in ''
     ${iptables} -t mangle -D OUTPUT -p tcp -m owner --uid-owner ${delugeUID} -j MARK --set-mark ${mark}
     ${iptables} -t mangle -D OUTPUT -p udp -m owner --uid-owner ${delugeUID} -j MARK --set-mark ${mark}
    '';

  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = 2; # Loose Reverse Path Filtering
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = 2;

  systemd.services.deluge-vpn-route = {
    description = "Deluge VPN routing";
    wantedBy = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    script = let
      ip = "${pkgs.iproute2}/bin/ip";
    in ''
    ${ip} rule add fwmark 0xca6c table 123
    ${ip} route add default dev deluge-conn table 123
  '';
    preStop = let
      ip = "${pkgs.iproute2}/bin/ip";
    in ''
    ${ip} rule del fwmark 0xca6c table 123
  '';
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.deluge-conn = {
    privateKeyFile = config.age.secrets.wireguard-key.path;
    ips = ["10.14.0.2/16"];
    table = "123"; # The custom routing table number
    fwMark = "0xca6c"; # The firewall mark used in iptables rules
    peers = [
      {
        publicKey = "peDjRPEdHHmo0hGootZ9f+MQCEXmziFkLhMTl2PeXRM=";
        allowedIPs = [ "34.117.118.44" ];
        endpoint = "dk-cph.prod.surfshark.com:51820";
      }
    ];
  };
