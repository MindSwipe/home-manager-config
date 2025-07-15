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
        tmuxPlugins.tmux-which-key
      ];

      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set-option -g mouse on
        set-option -g default-shell ${pkgs.fish}/bin/fish

        set -g @plugin 'omerxx/tmux-floax'
        set -g @plugin 'nhdaly/tmux-better-mouse-mode'

        # pane movement
        bind-key j command-prompt -p "join pane from:"  "join-pane -s :'%%'"
        bind-key s command-prompt -p "send pane to:"  "join-pane -t :'%%'"

        # override default splitting
        bind-key '"' split-window -c "#{pane_current_path}
        bind-key '%' split-window -h -c "#{pane_current_path}

        # Swap windows, this overrides the default "toggle layout"
        bind-key Space last-window
      '';
    };
  };
}