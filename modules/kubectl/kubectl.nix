{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.kubectl = {
    enable = lib.mkEnableOption "Kubernetes CLI";
  };

  config = lib.mkIf config.modules.kubectl.enable {
    home.packages = with pkgs; [
      kubectl
    ];
  };
}
