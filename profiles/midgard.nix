{ config, lib, pkgs, ... }:

with lib;

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
    openssl
    python37
    stdenv
    strace
    sudo
    sysstat
    tmux
    unzip
    vim
    vlc
    wget
    zip
  ];
  
  imports = [
    # Users on the machine
    ../users/midgard.nix

    # Configurations for packages
    ../pkgs/bash/config.nix
    ../pkgs/xserver/config.nix
    ../pkgs/syncthing/config.nix    
  ];

  time.timeZone = "Europe/Copenhagen";
  services.borgstadSyncthing = {
    enable = true;
    user = "borgstad";
  };

  services.borgstadUser = {
    user = "borgstad";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
}
