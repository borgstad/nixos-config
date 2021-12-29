{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.borgstadSyncthing;
in
{
  options.services.borgstadSyncthing = {
    user = mkOption {
      type = types.str;
    };
    enable = mkEnableOption "Syncthing wrapper";
  };

  config = mkIf cfg.enable {
    services = {
      syncthing = {
        enable = cfg.enable;
        user = cfg.user;
        configDir = "/home/${cfg.user}/.config/syncthing";
        devices = {
          galaxy21s = {
            id = "J5RIDPG-F6L7TKG-XYZ6SLL-3VZGRED-EJQ43TJ-MAHUPD3-6XRFRQL-H75YOQP";
            introducer = true;
            autoAcceptFolders = true;
          };
        };
        folders = {
          "/home/${cfg.user}/syncthing" = {
            label = "Base folder";
            id = "base-syncthing-folder";
            devices = [ "galaxy21s" ];
          };
        };
      };
    };
  };
}
