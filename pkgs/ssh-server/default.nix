{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    ports = [ 51537 ];
  };
  networking.firewall = {
    allowedTCPPorts = [
      51537
    ];
  };
}
