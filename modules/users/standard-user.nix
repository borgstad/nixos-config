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
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9+jQaQMrIzjuzWarrUaeL0hahsg5e22F26ma5v78Hh7trGox15ikbcFp0kKmE9YIeaAFamGWrOMdgIqpAp0mMdxlN7ReKqN3K9cy3IAmwi7ESWklMwz4aBhXRUqrnxw1zEJ+fHRaufRCYXxvlh5sbCAYJE3FH1DqvBERcQCSiyBiFHNS+k9posnCRNnLDknTrIswvz93mEvN1JUq9arjT6MBPvsIPNb0qKewxEFrbp48zNNe2ABFII6EeXEaYqsux0Z6kbsRUrhEowDIGuuOKO6CVDdXl/S662QO8jAzkxW7J2IOHIN5gmN27pTptLEQKOm0LDp7ydoJUChdB/HON9otJXX0e41N1UXKSrPrtjMoVwxKCeDi8YKAtGUo/uPWZ2jcIRuFuAzAN6izkkClpNaWHV3bJETCegvEsZRcMtRqeSkjSCI48BQ30vWHlBJ74Bd6GYemZe8uPUroPHFzo23ndMnTkq2lCjoUAt/mFUGwTt8T/MKxu4El5mO3ZU70= midgard@midgard"
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCtSyq/ShLJydZza5zswZDEyW/ghuS/WnX4EJbCKJ5iuSn7/ffmIy3VoWvmTj57iX09kIc2Cc1AfrnpFPywxdO+JHCm5Hvy7sph+uCJy9H8hZJAhHXE5hXy4ctLC/3Eg5eqaiHjtelEYBUh3yCTJbdXTDNH2Y9jp3tmnokyXFKVMOEF/oRQNCnnkENL63mTAH/3qRskBCNUC364h/eD+O48vO/Pi2KvWf62UCANI+Ltdk8SBBFZ0br4/u+OLQ60mgda3T4ulghNUXSNEBJdGuE2T8H32oIEh50XroLpu3HBzk+3I2U1rhmyLH+0UGyOS93d/tM/1Xn487Fc+cNZEMxROvEQ5MelLes5zgXz6jq95EsJjjosya0sThvsoPBv+nauDGadPMoDFH+7UIaJjpj8q470IvrNyQfp8K1W0v2tM8ZWtv4MCxF2tW+spJkq6ACZXTOuKKN7wP8dcsMbl5Y4AxqL/Xh/lspg740nWaZMiT/42AL1iGjS0/4WImbTbE= root@asgard" ];

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
