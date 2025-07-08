{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.gitCommands = {
    enable = lib.mkEnableOption "Custom git commands";
  };

  config = lib.mkIf config.modules.gitCommands.enable {
    home.sessionPath = [
      "${config.xdg.configHome}/gitCommands"
    ];

    xdg.configFile."gitCommands/git-feature".source = ./assets/git-feature;
  };
}