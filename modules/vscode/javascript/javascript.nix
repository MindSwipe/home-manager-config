{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.vscode.js = {
    enable = lib.mkEnableOption "JavaScript";
  };

  config = lib.mkIf config.modules.vscode.js.enable {
    home.packages = with pkgs; [
      nodejs
    ];

    modules.vscode = {
      additionalExtensions = with pkgs; [
        vscode-extensions.esbenp.prettier-vscode
        vscode-extensions.dbaeumer.vscode-eslint
        vscode-extensions.bradlc.vscode-tailwindcss
        vscode-extensions.redhat.vscode-yaml
        vscode-extensions.angular.ng-template
        vscode-marketplace."42crunch".vscode-openapi
      ];

      additionalUserSettings = {
        yaml.maxItemsComputed = 10000;
      };
    };
  };
}
