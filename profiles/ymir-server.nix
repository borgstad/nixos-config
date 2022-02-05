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
    emacs
    firefox
    gitAndTools.gitFull
    gnumake
    htop
    nix-prefetch-scripts
    mkpasswd
    openssl
    python37
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
  
  imports = [
    ../machines/jotunheim/hardware-configuration.nix
    ../machines/jotunheim/network.nix
    ../pkgs/bash
    ../pkgs/ssh-server
    ../pkgs/synapse
    ../pkgs/xserver
    ../pkgs/plex
    ../pkgs/deluge
    ../modules/syncthing
    ../modules/users/standard-user.nix
  ];
  nixpkgs.config.allowUnfree = true;
  
  services.borgstadSyncthing = {
    enable = true;
    user = "ymir";
  };
  services.borgstadUser = {
    user = "ymir";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
}
