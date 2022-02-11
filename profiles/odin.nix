{ config, lib, pkgs, ... }:

with lib;
  # Enable the X11 windowing system.

{
  environment.systemPackages = with pkgs; [
    alacritty
    aspell
    aspellDicts.en
    bash
    ctags
    curl
    element-desktop
    firefox
    gitAndTools.gitFull
    gnumake
    htop
    nix-prefetch-scripts
    mkpasswd
    openssl
    python37
    slack
    stdenv
    strace
    sudo
    sysstat
    tmux
    unzip
    vim
    wget
    zip
  ];
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../machines/asgard/hardware-configuration.nix
    ../machines/asgard/network.nix
    ../pkgs/bash
    ../pkgs/xserver
    ../pkgs/emacs
    ../modules/syncthing
    ../modules/users/standard-user.nix
  ];
  services.borgstadSyncthing = {
    enable = true;
    user = "odin";
  };
  services.borgstadUser = {
    user = "odin";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
    description = "Odin!";
  };
}
