{ config, pkgs, ... }:

{
  services = {
    syncthing = {
      enable = true;
      user = "midgard";
      configDir = "/home/midgard/.config/syncthing";
      declarative = {
        devices = {
          galaxy21s = {
            id = "J5RIDPG-F6L7TKG-XYZ6SLL-3VZGRED-EJQ43TJ-MAHUPD3-6XRFRQL-H75YOQP";
          };
        };
        folders = {
          "/home/midgard/syncthing" = {
            label = "Base folder";
            id = "base-syncthing-folder";
            devices = [ "galaxy21s" ];
          };
        };
      };
    };
  };
}
