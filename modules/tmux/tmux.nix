{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf config.modules.tmux.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;

      plugins = with pkgs; [
        tmuxPlugins.tmux-floax
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set-option -g mouse on
      '';
    };
  };
}