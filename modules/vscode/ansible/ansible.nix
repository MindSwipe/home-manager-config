{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.vscode.ansible = {
    enable = lib.mkEnableOption "Ansible";
  };

  config =
    let
      cfg = config.modules.vscode.ansible;
    in
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        ansible
        ansible-lint
        ansible-language-server
      ];

      modules.python.enable = true;

      modules.vscode = {
        additionalUserSettings = {
          "python.useEnvironmentsExtension" = false;
        };

        additionalExtensions = with pkgs; [
          vscode-extensions.redhat.ansible

          # required for the ansible extension
          vscode-extensions.ms-python.python
          vscode-extensions.ms-python.vscode-python-envs
          vscode-extensions.redhat.vscode-yaml
        ];
      };
    };
}
