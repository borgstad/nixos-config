{ config, lib, pkgs, ... }:

with lib;

{
  system.stateVersion = "20.09"; # Did you read the comment?
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
    k9s
    kompose
    kubectl
    kubernetes
    kustomize
    kubeseal
    k9s
    mkpasswd
    nix-prefetch-scripts
    openssl
    python37
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
    ../machines/jotunheim/hardware-configuration.nix
    ../machines/jotunheim/network.nix
    ../pkgs/bash
    ../pkgs/ssh-server
    ../pkgs/deluge
    ../pkgs/my-pages
    ../pkgs/media-servers-network
    ../pkgs/synapse
    ../pkgs/emacs
    ../pkgs/xserver
    ../pkgs/kubernetes
    # ../pkgs/grafana
    ../modules/syncthing
    ../modules/users/standard-user.nix
  ];
  nixpkgs.config.allowUnfree = true;

  services.borgstadSyncthing = {
    enable = true;
    user = "ymir";
  };
  virtualisation = {
    containerd.enable = true;
    docker.enable = true;
  };
  users.users.ymir.extraGroups = [ "docker" ];
  services.borgstadUser = {
    user = "ymir";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
  networking.firewall = {
    allowedTCPPorts = [ 8053 ];
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenpotr
  };
  services.vnstat.enable = true;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';
  # Once a day
  #system.autoUpgrade = {
  #  enable = true;
  #  channel = "https://nixos.org/channels/nixos-22.05";
  #};
  nix.settings.experimental-features = [ "nix-command flakes" ];
}
