{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.devenv = {
    enable = lib.mkEnableOption "devenv.sh";
  };

  config = lib.mkIf config.modules.devenv.enable {
    home.packages = with pkgs; [
      devenv
    ];
  };
}