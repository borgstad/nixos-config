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
    sshAuthKeysPath = mkOption {
      type = types.list;
    };
  };

  config = {
    users.extraUsers.ymir = {
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
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9+jQaQMrIzjuzWarrUaeL0hahsg5e22F26ma5v78Hh7trGox15ikbcFp0kKmE9YIeaAFamGWrOMdgIqpAp0mMdxlN7ReKqN3K9cy3IAmwi7ESWklMwz4aBhXRUqrnxw1zEJ+fHRaufRCYXxvlh5sbCAYJE3FH1DqvBERcQCSiyBiFHNS+k9posnCRNnLDknTrIswvz93mEvN1JUq9arjT6MBPvsIPNb0qKewxEFrbp48zNNe2ABFII6EeXEaYqsux0Z6kbsRUrhEowDIGuuOKO6CVDdXl/S662QO8jAzkxW7J2IOHIN5gmN27pTptLEQKOm0LDp7ydoJUChdB/HON9otJXX0e41N1UXKSrPrtjMoVwxKCeDi8YKAtGUo/uPWZ2jcIRuFuAzAN6izkkClpNaWHV3bJETCegvEsZRcMtRqeSkjSCI48BQ30vWHlBJ74Bd6GYemZe8uPUroPHFzo23ndMnTkq2lCjoUAt/mFUGwTt8T/MKxu4El5mO3ZU70= midgard@midgard" ];

    };

    system.activationScripts =
      {
        # Configure various dotfiles.
        dotfiles = stringAfter [ "users" ]
          ''
      cd /home/ymir
    '';
      };
  };
}
