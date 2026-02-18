{
  lib,
  config,
  self,
  pkgs,
  ...
}:
{
  options.modules.git = {
    enable = lib.mkEnableOption "git";

    allowedSigners = lib.mkOption {
      default = self + /assets/allowed_signers;
      example = self + /assets/allowed_signers;
      type = lib.types.path;
      description = "The path to the allowed signers file git should use, passed to the signing settings";
    };

    user = {
      name = lib.mkOption {
        default = null;
        example = "John";
        type = lib.types.nullOr lib.types.str;
        description = "The name used for git";
      };

      email = lib.mkOption {
        default = null;
        example = "john@doe.org";
        type = lib.types.nullOr lib.types.str;
        description = "The email used for git";
      };
    };

    core = {
      editor = lib.mkOption {
        default = "${lib.getExe pkgs.vscode} --wait";
        example = "code --wait";
        type = lib.types.str;
        description = "The command to use for the git editor";
      };
    };

    sshKey = lib.mkOption {
      default = null;
      example = "~/.ssh/id...";
      type = lib.types.nullOr lib.types.str;
      description = "The string path to the ssh id file used to sign commits";
    };

    additionalGitSettings = lib.mkOption {
      default = { };
      description = "Additional settings to map into the global git config file";
    };
  };

  config =
    let
      cfg = config.modules.git;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.user.name != null;
          message = "user.name option must be set for git module";
        }
        {
          assertion = cfg.user.email != null;
          message = "user.email option must be set for git module";
        }
        {
          assertion = cfg.sshKey != null;
          message = "sshKey option must be set for git module";
        }
      ];

      home.file.".ssh/allowed_signers".source = cfg.allowedSigners;

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = cfg.user.name;
            email = cfg.user.email;
          };

          core = {
            editor = cfg.core.editor;
          };

          push.autoSetupRemote = true;
          pull.rebase = true;

          gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        }
        // cfg.additionalGitSettings;

        signing = {
          format = "ssh";
          key = cfg.sshKey;
          signByDefault = true;
        };
      };
    };
}
