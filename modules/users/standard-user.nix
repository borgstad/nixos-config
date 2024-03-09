{ lib, config, ... }:

with lib;

let
  borgstadUserOptions = {
    options = {
      isAdmin = mkOption {
        type = types.bool;
        default = false;
        description = "Whether the user is an admin.";
      };
      sshKeys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of SSH keys for the user.";
      };
    };
  };
in {
  options.users.borgstadUser = mkOption {
    type = types.attrsOf (types.submodule borgstadUserOptions);
    default = {};
    description = "Borgstad user configurations.";
  };

  config = let
    userConfigs = config.users.borgstadUser;
  in mkIf (userConfigs != {}) {
    users.users = mapAttrs' (name: userCfg: nameValuePair name {
      isNormalUser = true;
      extraGroups = optional (userCfg.isAdmin) "wheel" ++ [ "networkmanager" "users" "media" ];
      openssh.authorizedKeys.keyFiles = userCfg.sshKeys;
    }) userConfigs;
  };
}
