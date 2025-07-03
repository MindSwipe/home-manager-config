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

  config = lib.mkIf config.modules.alacritty.enable {
    home.packages = [
      (config.lib.nixGL.wrap pkgs.alacritty)
    ];

    programs.alacritty = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.alacritty);

      settings = {
        terminal.shell = {
          args = ["new-session" "-A" "-D" "-s" "main"];
          program = "${pkgs.tmux}/bin/tmux";
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
      };
    };
  };
}