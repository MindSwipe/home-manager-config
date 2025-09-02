{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.vscode.dmn = {
    enable = lib.mkEnableOption "DMN/ BPMN/ Kogito extensions for VS Code";
  };

  config = lib.mkIf config.modules.vscode.dmn.enable {
    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-marketplace.kie-group.vscode-extension-kogito-bundle
      ];
    };
  };
}