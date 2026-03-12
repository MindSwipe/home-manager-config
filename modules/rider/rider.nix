{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.rider = {
    enable = lib.mkEnableOption "IntelliJ";
    package = lib.mkOption {
      default = pkgs.jetbrains.rider;
      example = pkgs.jetbrains.rider;
      type = lib.types.package;
      description = "Override the Rider package to use";
    };
  };

  config =
    let
      cfg = config.modules.rider;
    in
    lib.mkIf cfg.enable {
      home.packages = [
        cfg.package
      ];
    };
}
