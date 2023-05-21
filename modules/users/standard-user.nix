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
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCtSyq/ShLJydZza5zswZDEyW/ghuS/WnX4EJbCKJ5iuSn7/ffmIy3VoWvmTj57iX09kIc2Cc1AfrnpFPywxdO+JHCm5Hvy7sph+uCJy9H8hZJAhHXE5hXy4ctLC/3Eg5eqaiHjtelEYBUh3yCTJbdXTDNH2Y9jp3tmnokyXFKVMOEF/oRQNCnnkENL63mTAH/3qRskBCNUC364h/eD+O48vO/Pi2KvWf62UCANI+Ltdk8SBBFZ0br4/u+OLQ60mgda3T4ulghNUXSNEBJdGuE2T8H32oIEh50XroLpu3HBzk+3I2U1rhmyLH+0UGyOS93d/tM/1Xn487Fc+cNZEMxROvEQ5MelLes5zgXz6jq95EsJjjosya0sThvsoPBv+nauDGadPMoDFH+7UIaJjpj8q470IvrNyQfp8K1W0v2tM8ZWtv4MCxF2tW+spJkq6ACZXTOuKKN7wP8dcsMbl5Y4AxqL/Xh/lspg740nWaZMiT/42AL1iGjS0/4WImbTbE= root@asgard" 
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD6hsTS3aZw4xgI5U2L9gZmuzk2KwLL3pGqJuLpQlJDCN1r5+XW/2wqwAmE0fyPfj1x3o+6B2ms5i6yqitiCv53I0dbt7Kk+CJZvpLh7vcdIKDcuLTj6B07/o1dQ5AJ/80gc9TWQWzSk/b1nco4EiyGRHmwLEarpYnPFJBNsobzwhDKyRGj6A1rn9iYH68yXWlakivzF7PSh6ECWjtU0a8gIdhK4CsSlRXfiDj6MbrzjnIEPZojBSYM+H0qEh+UR7K6ZGOj5R0m058MGA9HdQXPzvRNdMGzVIfvPR2EhwvlMa2d8kXO4iXf7c8+PMxa9PUPBOfkgMHMkjMwLLu52RGimJLeGoKbr3C6KnJFPd0QMWbM4RE1hlzncVOZCWLDo4WIvMbnl1Odsx5mnbA9hJvNt/s4W9gmi0NzlGT2JN2CNZohnf6VjLlZbpIwBd7nmpR3t/Vl1LJnfBr/F1Il3OWwDIFC0pgOBI0PTzs0ofkuJlYqb+NbEciUcogA2uErs3c= M102376@WN01943" 
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZoh7nECBotz77i7v8KrMLdSrNzb/f7XjPM5xgeVh5pgWc/yftjmyJgZJJ1ZFGHpdq4p8upUPJEyrbuIsjZ77EvnLyQpgl6ZdU2sDhOLlkzMpfB9jOco727NHfOHgLIgig7mw13jfRA9wUA8EtQvBCVaI1QJC2JcxkeM3Txwq4w0CnbzAonptebcQ2itg0QQiY9R+nSPR3HqCa6Lh6wNdRsRt5XpErMqwzZYUi6Ig9lKgZ8BmwHfG9mCmKwAzZo0WCTs0i7hit6j8D7adq9aWoESiq7JESisYmxbz26YspiPbQvgUvT1vmPv4ccFwC2odv82AfBO5C9gIh4IjarRupYV+fcVd2jHvJR+b83xA27URFEM3y0ebcMA2dy6APBf4D0jsNlHyIBFPvN8dL0tp7qXPtNW5S0/hooKuyKWOYLukXRD2N1KbS1QjfcGz/k+xN8HvQwtCg6GB4vDj+EdigM1QHrwz5E7hGmiiGjA/VqfJzJNtiUIRBBUqKiLshxW8= borg@lagertha"
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHug2giBB8u8/ee/FapE2F9/pESohSmovFbgoHwjf9q/9o8EECh41M8i+DmyYimX1O/8skVisw4j7YvLv5db5W7VbSdhM33Lep6vxCKtYmyCFB91af3fIw39+UzKaKqOUjxNdN1YHfqCVDSRIyqdohlwAe5h0trBWbmubCoIBNsEGgf+fsMjIlOWDrdJkAlyynDAhfsqRS0/Bzv308uEFgrgjfamBzTjq0fK192b71AAFSriMdfBxitu7qbXqMALLezsCAZdacmWeFlthfKoBmj42Z8A9tIRud5JaKFuKbkbE22iu+zuoH/HEJvFyia71xjFxkVeQCPvtgg+qBMApco6MiPmvLhuC5+Rc0SGtZU3NBV8z8BawpiXGWFgB9foGKoB+/QqRUcmwtQR1F+wYDunGK8ITHBzg1ZCdr2PmabsX5JhOqGZJeywg28G7Ahw9ogyyl23Futd554bUyXfTmitxEBJ/fpOC8KG9te5r74Vvsxfx3UPXEOCTUc1DBtU0= bob@bob"];

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
