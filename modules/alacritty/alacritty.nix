{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal emulator";
  };

  config =
    let
      cfg = config.modules.alacritty;
      tmuxConf = config.modules.tmux;
      fishConf = config.modules.fish;
    in
    lib.mkIf cfg.enable {
      home.packages = [
        (config.lib.nixGL.wrap pkgs.alacritty)
      ];

      programs.alacritty = {
        enable = true;
        package = (config.lib.nixGL.wrap pkgs.alacritty);

        settings = {
          terminal.shell = {
            program =
              if tmuxConf.enable then
                "${lib.getExe pkgs.tmux}"
              else if fishConf.enable then
                "${lib.getExe config.programs.fish.package}"
              else
                "/usr/bin/env bash";

            args = lib.mkIf tmuxConf.enable [
              "new-session"
              "-t"
              "main"
            ];
          };

          font = {
            normal = {
              family = "MesloLGS NF";
              style = "Regular";
            };
            bold = {
              family = "MesloLGS NF";
              style = "Bold";
            };
            italic = {
              family = "MesloLGS NF";
              style = "Italic";
            };
          };

          window = {
            resize_increments = true;
          };
        };
      };
    };
}
