{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.fish = {
    enable = lib.mkEnableOption "Fish shell";
    sssd = {
      uses = lib.mkOption {
        default = false;
        example = false;
        type = lib.types.bool;
        description = "Whether or not the target system uses SSSD for authentication";
      };

      libnssSssPath = lib.mkOption {
        default = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
        example = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
        type = lib.types.str;
        description = "The path to the libnss_sss library";
      };
    };
  };

  config =
    let
      cfg = config.modules.fish;
    in
    lib.mkIf cfg.enable {
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
        ''
        + lib.optionalString cfg.sssd.uses ''
          set -gx LD_PRELOAD "$LD_PRELOAD ${cfg.sssd.libnssSssPath}" 
        '';

        plugins = [
          {
            name = "tide";
            src = pkgs.fishPlugins.tide.src;
          }
          {
            name = "fzf";
            src = pkgs.fishPlugins.fzf.src;
          }
        ];
      };
    };
}
