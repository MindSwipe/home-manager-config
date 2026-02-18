{
  lib,
  config,
  ...
}:
{
  options.modules.delta = {
    enable = lib.mkEnableOption "Delta git pager";
  };

  config = lib.mkIf config.modules.delta.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    modules.git.additionalGitSettings = {
      merge.conflictStyle = "zdiff3";
      delta.navigate = true;
    };
  };
}
