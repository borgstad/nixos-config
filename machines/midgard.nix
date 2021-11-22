{ config, lib, pkgs, ... }:

with lib;

#let secrets = import ./secrets.nix;

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
    ../users/midgard.nix

    # Configurations for packages
    ../pkgs/bash/config.nix
  ];

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";
  networking = {
    hostName = "midgard";
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    nameservers = [ "192.168.0.185" ];
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  boot = {
    # Disable console blanking after being idle
    kernelParams = ["consoleblank=0"];

    # clean /tmp on startup
    cleanTmpDir = true;
  };
}
