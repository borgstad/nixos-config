{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      ./deluge.nix
      ./users.nix
    ];
