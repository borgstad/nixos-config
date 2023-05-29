{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    ports = [ 51537 ];
  };
  networking.firewall = {
    allowedTCPPorts = [
      51537
    ];
  };
}
