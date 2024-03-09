{ inputs, config, lib, pkgs, ... }:
with builtins;
with lib;
let
  inherit (inputs) agenix;
in
{
  imports = [ agenix.nixosModules.age ];
  age.secrets.deluge-pass = {
    file = ./deluge-pass.age;
    owner = "deluge";
    group = "media";
  };
  age.secrets.wireguard-key = {
    file = ./wireguard-key.age;
    owner = "root";
    group = "root";
  };
  age.secrets.matrix-synapse-secret = {
    file = ./matrix-synapse-secret.age;
    owner = "turnserver";
    group = "turnserver";
  };

}
