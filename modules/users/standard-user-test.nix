{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bbtest;
  userOpts = { name, config, ... }: {
    options = { 
      name = mkOption {
        type = types.str;
      };
      isAdmin = mkOption {
        type = types.bool;
      };
      hashedPasswordPath = mkOption {
        type = types.str;
      };
    };
  };

in {
  options.services.bbtest = mkOption {
    default  = {};
    type = with types; attrsOf (submodule userOpts);
  };

  config = {
    users.extraUsers.${config.isAdmin} = {
      description = "Mega server user";
      extraGroups = [
        "networkmanager"
        "users"
        "wheel"
      ];
      isNormalUser = true;
      createHome = true;
      home = "/home/${cfg.name}";
      #openssh.authorizedKeys.keys = secrets.sshKeys.yeah;
      # mkpasswd -m sha-512
      hashedPassword = "$6$q24dXEvpmBMXFhlJ$H4MM4.QKwkqu7PuJVK4hdYRW5Jq..crhZF12kr.QU5reXI4kKf0r1ZBQkZb9IVQ0XV7BTgE7NfSRTLvJGf0ZQ1";
    };
    system.activationScripts =
      {
        # Configure various dotfiles.
        dotfiles = stringAfter [ "users" ]
          ''
      cd /home/${cfg.name}
    '';
      };
  };
}
