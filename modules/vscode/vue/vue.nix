{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.vscode.vue = {
    enable = lib.mkEnableOption "Vue support in VS Code";
  };

  config = lib.mkIf config.modules.vscode.vue.enable {
    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-extensions.vue.volar
      ];
    };
  };
}