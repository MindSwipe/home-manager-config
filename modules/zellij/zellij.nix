{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.modules.zellij = {
    enable = lib.mkEnableOption "Zellij";
    additionalLayouts = lib.mkOption {
      default = null;
      example = ./your/additional/layouts;
      type = lib.types.nullOr lib.types.path;
      description = "Any additional Zellij layouts that you want to use";
    };
  };

  config = lib.mkIf config.modules.zellij.enable {
    home.packages = with pkgs; [ zellij ];

    home.file = {
      ".config/zellij/config.kdl".source = ./assets/config.kdl;
    };

    home.file.additionalLayouts =
      lib.mkIf (config.modules.zellij.additionalLayouts != null)
        {
          recursive = true;
          source = config.homeModules.applications.zellij.additionalLayouts;
          target = ".config/zellij/layouts";
        };
  };
}