{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./nix/vscode-nix.nix
    ./javascript/javascript.nix
    ./fish/fish.nix
    ./dmn/dmn.nix
  ];

  options.modules.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";
    telemetry = lib.mkOption {
      default = "off";
      example = "off";
      type = lib.types.enum [
        "all"
        "error"
        "crash"
        "off"
      ];
    };

    additionalExtensions = lib.mkOption  {
      default = [ ];
      example = [ ];
      type = lib.types.listOf lib.types.package;
      description = "Additional extensions for VS Code";
    };

    additionalUserSettings = lib.mkOption {
      default = { };
      description = "Additional user settings for VS Code";
    };
  };

  config = lib.mkIf config.modules.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = with pkgs;
          [
            vscode-extensions.tomoki1207.pdf
          ]
          ++ config.modules.vscode.additionalExtensions;
        
        userSettings =
          {

          }
          // config.modules.vscode.additionalUserSettings;
      };
    };
  };
}
