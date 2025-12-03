{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.vscode.nix = {
    enable = lib.mkEnableOption "Nix support in VS Code";
  };

  config = lib.mkIf config.modules.vscode.nix.enable {
    home.packages = with pkgs; [
      nixfmt-rfc-style
      nixd
      deadnix
    ];

    modules.vscode = {
      additionalExtensions = with pkgs; [ vscode-extensions.jnoortheen.nix-ide ];
      additionalUserSettings = {
        nix.enableLanguageServer = true;
        nix.serverPath = "nixd";
        nix.serverSettings = {
          nixd = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };

        "[nix]" = {
          editor.formatOnSave = true;
        };
      };
    };
  };
}
