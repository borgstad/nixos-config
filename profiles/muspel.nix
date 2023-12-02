{ config, lib, pkgs, inputs, ... }:

with lib;

{
  system.stateVersion = "23.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    alacritty
    aspell
    aspellDicts.en
    ctags
    curl
    docker-compose  
    direnv
    element-desktop
    firefox
    gcc
    vlc
    libvlc
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
    spotify
    strace
    sudo
    sysstat
    sqlite
    unzip
    vscode
    vnstat
    vim
    wget
    zip
    zsh
    libreoffice-qt
    hunspell
    # hunspellDicts.bg_BG
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
  services.borgstadUser = {
    user = "muspel";
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

  systemd.user.services.startupFirefox = {
    enable = true;
    unitConfig = {
      Description = "Start Firefox on login";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    serviceConfig = {
      ExecStart = "${pkgs.firefox}/bin/firefox";
      Restart = "on-failure";
    };
  };
  virtualisation.docker.enable = true;
  users.users.muspel.extraGroups = [ "docker" ];
  
}
