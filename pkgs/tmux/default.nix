{ programs, ...}:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -g default-terminal "screen-256color"
    '';
  };
}
