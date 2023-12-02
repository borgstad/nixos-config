{ config, lib, pkgs, ... }:

with lib;
  # Enable the X11 windowing system.

{
  environment.systemPackages = with pkgs; [
    alacritty
    aspell
    anki
    aspellDicts.en
    bash
    ctags
    curl
    graphviz
    element-desktop
    firefox
    gcc
    gitAndTools.gitFull
    gnumake
    htop
    mkpasswd
    nix-prefetch-scripts
    nodejs
    openssl
    python37
    slack
    sqlite
    okular
    stdenv
    strace
    sudo
    sysstat
    go
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
    # ../pkgs/bash
    ../pkgs/zsh
    ../pkgs/emacs
    ../pkgs/xserver
    ../modules/syncthing
    ../modules/users/standard-user.nix
  ];

  (final: prev: {
  anki = prev.anki.overrideAttrs (oldAttrs: rec {
    version = "2.1.28";
    pname = oldAttrs.pname;
    src = prev.fetchurl {
      urls = [
        "https://github.com/ankitects/anki/archive/${version}.tar.gz"
      ];
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
  });
  })

  services.borgstadSyncthing = {
    enable = true;
    user = "odin";
  };
  services.borgstadUser = {
    user = "odin";
    isAdmin = true;
    hashedPasswordPath = "";
    sshAuthKeysPath = [ "" ];
  };
  virtualisation.docker.enable = true;
  users.users.odin.extraGroups = [ "docker" ];
  users.users.odin.shell = pkgs.zsh;
  users.defaultUserShell = pkgs.zsh;
}
