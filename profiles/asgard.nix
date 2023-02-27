{ config, lib, pkgs, ... }:

with lib;
  # Enable the X11 windowing system.

{
  environment.systemPackages = with pkgs; [
    alacritty
    anki
    aspell
    aspellDicts.en
    bash
    ctags
    curl
    element-desktop
    firefox
    gcc
    gitAndTools.gitFull
    gnumake
    go
    graphviz
    htop
    mkpasswd
    nix-prefetch-scripts
    nodejs
    okular
    openssl
    pinentry
    pkgs.dwarf-fortress-packages.dwarf-fortress-full
    python37
    rustup
    slack
    sqlite
    stdenv
    spotifyd
    spotify-tui
    strace
    SDL2
    sudo
    sysstat
    teams
    tmux
    unzip
    vim
    vscode
    wget
    wireguard-tools
    zip
  ];
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../machines/asgard/hardware-configuration.nix
    ../machines/asgard/network.nix
    ../pkgs/wireguard
    ../pkgs/zsh
    ../pkgs/steam
    # ../pkgs/ssh-server

    # ../pkgs/openvpn
    ../pkgs/emacs
    ../pkgs/xserver
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
  };
  virtualisation.docker.enable = true;
  users.users.odin.extraGroups = [ "docker" ];
  users.users.odin.shell = pkgs.zsh;
  users.defaultUserShell = pkgs.zsh;

  services.gnome.gnome-online-accounts.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.seahorse.enable = lib.mkForce false;
  services.pcscd.enable = true;
  programs.gnupg.agent.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 8888 ]; # Clients and peers can use the same port, see listenpotr
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];


}
