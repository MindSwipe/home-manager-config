{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.fish = {
    enable = lib.mkEnableOption "Fish shell";
  };

  config = lib.mkIf config.modules.fish.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      font-awesome
      nerd-fonts.ubuntu
      meslo-lgs-nf
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';

      plugins = [
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      ];
    };
  };
}