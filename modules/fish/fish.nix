{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.fish = {
    enable = lib.mkEnableOption "Fish shell";
  };

  config = lib.mkIf config.modules.fish.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      font-awesome
      nerd-fonts.ubuntu
      meslo-lgs-nf
      fzf
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        bind ctrl-h backward-kill-bigword
        bind ctrl-delete kill-bigword

        set --universal tide_right_prompt_items status cmd_duration context nix_shell
      '';

      plugins = [
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
        { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      ];
    };
  };
}