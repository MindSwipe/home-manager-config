{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.vscode.fish = {
    enable = lib.mkEnableOption "Fish extensions for VS Code";
  };

  config = lib.mkIf config.modules.vscode.fish.enable {
    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-extensions.skyapps.fish-vscode
      ];
    };
  };
}
