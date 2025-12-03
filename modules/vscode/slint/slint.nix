{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.vscode.slint = {
    enable = lib.mkEnableOption "Slint support in VS Code";
  };

  config = lib.mkIf config.modules.vscode.slint.enable {
    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-marketplace.slint.slint
      ];
    };
  };
}
