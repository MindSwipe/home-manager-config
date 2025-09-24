{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.vscode.wgsl = {
    enable = lib.mkEnableOption "WGSL support in VS Code";
  };

  config = lib.mkIf config.modules.vscode.wgsl.enable {
    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-marketplace.wgsl-analyzer.wgsl-analyzer
      ];
    };
  };
}