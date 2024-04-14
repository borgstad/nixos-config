{ config, lib, pkgs, inputs, ... }:

with lib;

{
  system.stateVersion = "23.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
        # hunspellDicts.bg_BG
    aspell
    aspellDicts.en
    ctags
    curl
    direnv
    element-desktop
    # emacs29
    firefox
    gcc
    gitAndTools.gitFull
    gnumake
    graphviz
    htop
    hunspell
    inputs.agenix.packages."${system}".default
    libreoffice-qt
    litecli # sqlite client
    mkpasswd
    nix-prefetch-scripts
    openssl
    python310
    (python310.withPackages(ps: with ps; [ pandas requests tabulate ]))
    spotify
    sqlite
    stdenv
    strace
    sudo
    sysstat
    unzip
    vim
    vnstat
    vscode
    wget
    zip
    zsh
alacritty
  ];
  environment.shells = with pkgs; [ zsh ];

  imports = [
    # ../pkgs/grafana
    ../machines/muspel/hardware-configuration.nix
    ../modules/syncthing
    ../modules/users/standard-user.nix
    ../pkgs/zsh
    ../pkgs/emacs
    ../pkgs/ssh-server
    ../pkgs/tmux
    ../pkgs/vs-code
    ../pkgs/xserver
  ];
  nixpkgs.config.allowUnfree = true;

  services.borgstadSyncthing = {
    enable = true;
    user = "muspel";
  };
  users.borgstadUser.muspel = {
    isAdmin = true;
  };
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  services.vnstat.enable = true;
  users.defaultUserShell = pkgs.zsh;
  nix.settings.experimental-features = [ "nix-command flakes" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

}
