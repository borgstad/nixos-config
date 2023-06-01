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
}
