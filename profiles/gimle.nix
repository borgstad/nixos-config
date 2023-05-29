{ config, lib, pkgs, ... }:

with lib;

{
  system.stateVersion = "22.11"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    alacritty
    aspell
    aspellDicts.en
    ctags
    curl
    direnv
    element-desktop
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
    zsh
  ];
  environment.shells = with pkgs; [ zsh ];

  imports = [
    # ../pkgs/grafana
    ../machines/gimle/hardware-configuration.nix
    ../machines/gimle/network.nix
    ../modules/syncthing
    ../modules/users/standard-user.nix
    ../pkgs/zsh
    ../pkgs/emacs
    ../pkgs/entertainment-system
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
  users.defaultUserShell = pkgs.zsh;
  nix.settings.experimental-features = [ "nix-command flakes" ];
}
