{ config, pkgs, ... }:
{
  services.openvpn.servers = {
    dk = { config = '' config /etc/nixos/pkgs/openvpn/server.ovpn''; };
  };
}
