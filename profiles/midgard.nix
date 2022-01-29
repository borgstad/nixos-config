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
    ../machines/midgard/hardware-configuration.nix
    ../machines/midgard/network.nix
    # Configurations for packages
    ../pkgs/bash
    ../pkgs/xserver
    ../modules/syncthing
    ../modules/users/standard-user.nix
  ];
  services.borgstadSyncthing = {
    enable = true;
    user = "midgard";
  };

  services.borgstadUser = {
    user = "midgard";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
}
