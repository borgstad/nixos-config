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
    docker
    element-desktop
    emacs
    firefox
    gitAndTools.gitFull
    gnumake
    htop
    kompose
    kubectl
    kubernetes
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
    ../pkgs/my-pages
    ../pkgs/media-servers-network
    ../pkgs/synapse
    ../pkgs/emacs
    ../pkgs/xserver
    # ../pkgs/kubernetes
    ../pkgs/grafana
    ../modules/syncthing
    ../modules/users/standard-user.nix
  ];
  nixpkgs.config.allowUnfree = true;

  services.borgstadSyncthing = {
    enable = true;
    user = "ymir";
  };
  virtualisation.docker.enable = true;
  users.users.ymir.extraGroups = [ "docker" ];
  services.borgstadUser = {
    user = "ymir";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
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

}
