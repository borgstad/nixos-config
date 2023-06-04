{config, pkgs, lib, ...}:

{
  users.groups.media = {
    members = ["surt"
               "deluge"
               "sonarr"
               "radarr"
               "jellyfin"
               "prowlarr"
              ];
  };
}
