{ config, pkgs, ... }:

{
    programs.zsh = {
     enable = true;
     ohMyZsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
    };
    environment.systemPackages = with pkgs; [
      thefuck
    ];
    # Chat apps
}
