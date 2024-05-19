{config, pkgs, lib, ...}:

{
  users.groups.media = {
    members = ["surt"
               config.services.bazarr.user
               config.services.deluge.user
               config.services.jellyfin.user
               config.services.radarr.user
               config.services.sonarr.user
              ];
  };
}
