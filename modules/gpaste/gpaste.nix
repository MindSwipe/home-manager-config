{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.gpaste = {
    enable = lib.mkEnableOption "gpaste";
  };

  config = lib.mkIf config.modules.gpaste.enable {
    home.packages = with pkgs; [
      gpaste
    ];
  };
}
