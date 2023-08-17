{ config, lib, pkgs, inputs, ... }:

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
    litecli # sqlite client
    gitAndTools.gitFull
    inputs.agenix.packages."${system}".default
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
    sqlite
    unzip
    vnstat
    vim
    wget
    zip
    zsh
  ];
  environment.shells = with pkgs; [ zsh ];

  imports = [
    ../machines/gimle/hardware-configuration.nix
    ../machines/gimle/network.nix
    ../modules/syncthing
    ../modules/users/standard-user.nix
    ../pkgs/grafana
    ../pkgs/zsh
    ../pkgs/emacs
    ../pkgs/htpc
    ../pkgs/xrdp
    # ../pkgs/wireguard
    #../pkgs/kubernetes
    #../pkgs/media-servers-network
    ../pkgs/my-pages
    ../pkgs/ssh-server
    ../pkgs/synapse
    ../pkgs/tmux
    ../pkgs/vs-code
    ../pkgs/xserver
  ];
  nixpkgs.config.allowUnfree = true;

  services.borgstadSyncthing = {
    enable = true;
    user = "surt";
  };
  # inputs.sometest.services.autobrr.enable = true;

  services.borgstadUser = {
    user = "surt";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.vnstat.enable = true;
  users.defaultUserShell = pkgs.zsh;
  nix.settings.experimental-features = [ "nix-command flakes" ];
}
