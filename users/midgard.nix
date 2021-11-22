{ config, lib, pkgs, ... }:
with lib;

#let secrets = import ../secrets.nix;
#in
{
  users.extraUsers.midgard = {
    description = "Andreas' profile";
    extraGroups = [
      "networkmanager"
      "users"
      "wheel"
    ];

    isNormalUser = true;
    createHome = true;
    home = "/home/midgard";

    #openssh.authorizedKeys.keys = secrets.sshKeys.yeah;

  };

  system.activationScripts =
  {
    # Configure various dotfiles.
    dotfiles = stringAfter [ "users" ]
    ''
      cd /home/midgard
    '';
  };
}
