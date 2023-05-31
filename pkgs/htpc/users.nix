{config, pkgs, lib, ...}:

{
  users.groups.media = {
    members = ["surt"];
    gid = 2000;
  };
  # users.users.deluge = {
  #   isSystemUser = true;
  #   uid = 1100;
  #   group = "media";
  # };
  users.users.sonarr = {
    isSystemUser = true;
    uid = 1101;
    group = "media";
  };
  users.users.radarr = {
    isSystemUser = true;
    uid = 1102;
    group = "media";
  };
  # users.users.jellyfin = {
  #   isSystemUser = true;
  #   uid = 1103;
  #   group = "media";
  # };
  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      7878
      9696
      8989
      8112
      5438
      8265
    ];
  };
}
