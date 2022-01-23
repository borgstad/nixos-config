{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.borgstadUser;
# let secrets = import ../secrets.nix;
in
{
  options.services.borgstadUser = {
    user = mkOption {
      type = types.str;
    };
    isAdmin = mkOption {
      type = types.bool;
    };
    hashedPasswordPath = mkOption {
      type = types.str;
    };
  };

  config = {
    users.extraUsers.${cfg.user} = {
      description = "Mega server user";
      extraGroups = [
        "networkmanager"
        "users"
        "wheel"
      ];
      isNormalUser = true;
      createHome = true;
      home = "/home/${cfg.user}";
      #openssh.authorizedKeys.keys = secrets.sshKeys.yeah;
      # mkpasswd -m sha-512
      hashedPassword = "$6$q24dXEvpmBMXFhlJ$H4MM4.QKwkqu7PuJVK4hdYRW5Jq..crhZF12kr.QU5reXI4kKf0r1ZBQkZb9IVQ0XV7BTgE7NfSRTLvJGf0ZQ1";
    };
    system.activationScripts =
      {
        # Configure various dotfiles.
        dotfiles = stringAfter [ "users" ]
          ''
      cd /home/${cfg.user}
    '';
      };
  };
}