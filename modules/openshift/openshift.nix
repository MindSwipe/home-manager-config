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
    home.sessionPath = [
      "${config.xdg.configHome}/openshiftScripts"
    ];

    home.packages = with pkgs; [
      openshift
    ];

    xdg.configFile."openshiftScripts/ocfl".source = ./assets/ocfl;
  };
}