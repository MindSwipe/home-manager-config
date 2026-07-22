{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.python = {
    enable = lib.mkEnableOption "Python installation";
    setupVscode = lib.mkEnableOption "Settings and extensions for Python development in VS Code";
    integrateTreefmt = lib.mkEnableOption "Add an additional formatter to treefmt for Python";
  };

  config =
    let
      cfg = config.modules.python;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        python3
      ];

      modules.vscode = lib.mkIf cfg.setupVscode {
        additionalUserSettings = {
          "[python]" = {
            "editor.defaultFormatter" = "ms-python.black-formatter";
            "editor.formatOnSave" = true;
          };
        };

        additionalExtensions = with pkgs; [
          vscode-extensions.ms-python.python
          vscode-extensions.ms-python.debugpy
          vscode-extensions.ms-python.black-formatter
        ];
      };

      modules.treefmt.additionalFormatters = lib.mkIf cfg.integrateTreefmt [
        {
          name = "black";
          command = "black";
          includes = [
            "*.py"
            "*.pyi"
          ];
          package = pkgs.black;
        }
      ];
    };
}
