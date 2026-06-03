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

  config =
    let
      cfg = config.modules.tmux;
      shell =
        if config.modules.fish.enable then lib.getExe config.programs.fish.package else "/usr/bin/env bash";
    in
    lib.mkIf cfg.enable {
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
          set-option -g default-shell ${shell}

          set -g @plugin 'omerxx/tmux-floax'
          set -g @plugin 'nhdaly/tmux-better-mouse-mode'

          # pane movement
          bind-key j command-prompt -p "join pane from:"  "join-pane -s :'%%'"
          bind-key s command-prompt -p "send pane to:"  "join-pane -t :'%%'"

          # override default splitting
          bind-key '"' split-window -c "#{pane_current_path}"
          bind-key '%' split-window -h -c "#{pane_current_path}"

          # override default creation of new window
          bind-key 'c' new-window -c "#{pane_current_path}"

          # Swap windows, this overrides the default "toggle layout"
          bind-key Space last-window

          # start numbering windows at 1
          set -g base-index 1
        '';
      };
    };
}
