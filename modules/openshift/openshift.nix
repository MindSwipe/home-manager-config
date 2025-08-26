{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.openshift = {
    enable = lib.mkEnableOption "OpenShift CLI";
  };

  config = lib.mkIf config.modules.openshift.enable {
    home.packages = with pkgs; [
      openshift
    ];
  };
}