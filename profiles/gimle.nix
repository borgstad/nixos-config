{ config, lib, pkgs, ... }:

with lib;

{
  system.stateVersion = "22.11"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    alacritty
    aspell
    aspellDicts.en
    bash
    ctags
    curl
    docker
    docker-compose
    direnv
    element-desktop
    emacs
    firefox
    gitAndTools.gitFull
    gnumake
    htop
    mkpasswd
    nix-prefetch-scripts
    openssl
    python310
    stdenv
    strace
    sudo
    sysstat
    tmux
    unzip
    vnstat
    vim
    wget
    zip
  ];

  imports = [
    # ../pkgs/grafana
    ../machines/gimle/hardware-configuration.nix
    ../machines/gimle/network.nix
    ../modules/syncthing
    ../modules/users/standard-user.nix
    ../pkgs/bash
    ../pkgs/deluge
    ../pkgs/emacs
    #../pkgs/kubernetes
    #../pkgs/media-servers-network
    #../pkgs/my-pages
    ../pkgs/ssh-server
    #../pkgs/synapse
    #../pkgs/vs-code
    ../pkgs/xserver
  ];
  nixpkgs.config.allowUnfree = true;

  services.borgstadSyncthing = {
    enable = true;
    user = "surt";
  };
  services.borgstadUser = {
    user = "surt";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
  services.vnstat.enable = true;
  nix.settings.experimental-features = [ "nix-command flakes" ];
}
