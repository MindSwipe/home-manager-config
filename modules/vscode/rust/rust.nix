{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.vscode.rust = {
    enable = lib.mkEnableOption "rust support in VS Code";
  };

  config = lib.mkIf config.modules.vscode.rust.enable {
    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-extensions.rust-lang.rust-analyzer
      ];
    };
  };
}
