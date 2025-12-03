{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.bruno = {
    enable = lib.mkEnableOption "Bruno API testing";
  };

  config = lib.mkIf config.modules.bruno.enable {
    home.packages = [
      (config.lib.nixGL.wrap pkgs.bruno)
    ];
  };
}
