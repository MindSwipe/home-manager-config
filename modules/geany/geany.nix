{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.geany = {
    enable = lib.mkEnableOption "Geany";
  };

  config = lib.mkIf config.modules.geany.enable {
    home.packages = with pkgs; [
      geany
    ];
  };
}
