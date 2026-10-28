{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.java = {
    enable = lib.mkEnableOption "Java installation";
    package = lib.mkOption {
      default = pkgs.temurin-bin-17;
      example = pkgs.temurin-bin-17;
      type = lib.types.package;
      description = "Which JDK to install";
    };

    mvnd = lib.mkOption {
      default = true;
      example = true;
      type = lib.types.bool;
      description = "Whether or not to install mvnd";
    };
  };

  config = lib.mkIf config.modules.java.enable {
    home.packages =
      with pkgs;
      [
        maven
      ]
      ++ lib.optionals config.modules.java.mvnd [
        mvnd
      ];

    programs.java = {
      enable = true;
      package = config.modules.java.package;
    };
  };
}
