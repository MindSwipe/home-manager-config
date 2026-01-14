{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.intellij = {
    enable = lib.mkEnableOption "IntelliJ";
    package = lib.mkOption {
      default = pkgs.jetbrains.idea;
      example = pkgs.jetbrains.idea;
      type = lib.types.package;
      description = "Override the IntelliJ package to use";
    };

    mvnd = lib.mkOption {
      default = true;
      example = true;
      type = lib.types.bool;
      description = "Whether or not to install mvnd";
    };

    jdk = lib.mkOption {
      default = pkgs.openjdk8;
      example = pkgs.openjdk8;
      type = lib.types.package;
      description = "Which JDK to install";
    };

    wildfly = {
      enable = lib.mkEnableOption "Wildfly installation";
      package = lib.mkOption {
        default = pkgs.wildfly-bin;
        example = pkgs.wildfly-bin;
        type = lib.types.package;
        description = "The Nix package containing WildFly";
      };
    };
  };

  config = lib.mkIf config.modules.intellij.enable {
    home.packages =
      with pkgs;
      [
        config.modules.intellij.package
        maven
      ]
      ++ lib.optionals config.modules.intellij.mvnd [
        mvnd
      ]
      ++ lib.optionals config.modules.intellij.wildfly.enable [
        config.modules.intellij.wildfly.package
      ];

    programs.java = {
      enable = true;
      package = config.modules.intellij.jdk;
    };
  };
}
