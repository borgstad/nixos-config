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
}
