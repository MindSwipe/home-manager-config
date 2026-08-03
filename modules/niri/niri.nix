{
  config,
  lib,
  pkgs,
  niri,
  dms,
  ...
}:
{
  imports = [
    dms.homeModules.dank-material-shell
    dms.homeModules.niri
    niri.homeModules.niri
  ];

  options.modules.niri = {
    enable = lib.mkEnableOption "Niri WM";

    sudoPath = lib.mkOption {
      default = "/usr/bin/sudo";
      example = "/usr/bin/suod";
      type = lib.types.str;
      description = "Absolute path to the system installed sudo binary";
    };

    cmpPath = lib.mkOption {
      default = "/usr/bin/cmp";
      example = "/usr/bin/cmp";
      type = lib.types.str;
      description = "Absolute path to the system installed cmp binary";
    };
  };

  config =
    let
      cfg = config.modules.niri;

      niriDesktopEntry = (
        niriPackage:
        pkgs.writeText "niri.desktop" ''
          [Desktop Entry]
          Name=niri
          Comment=Scrollable-tiling Wayland compositor
          Exec=${lib.getExe niriPackage}
          Type=Application
          DesktopNames=niri
        ''
      );
    in
    lib.mkIf cfg.enable {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

      programs.dank-material-shell = {
        enable = true;
        niri = {
          enableSpawn = true;
          includes.enable = true;
        };

        settings = {
          theme = "dark";
          dynamicTheming = true;
        };

        session = {
          isLightMode = false;
        };

        clipboardSettings = {
          maxHistory = 25;
          maxEntrySize = 5242880;
          autoClearDays = 1;
          clearAtStartup = true;
          disabled = false;
          disableHistory = false;
          disablePersist = true;
        };
      };

      home.activation.installNiriSession = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        desktopFile="${(niriDesktopEntry config.programs.niri.package)}"
        targetFile="/usr/share/wayland-sessions/niri.desktop"

        if ! ${cfg.cmpPath} --silent "$desktopFile" "$targetFile" 2>/dev/null; then
          run ${cfg.sudoPath} install -Dm644 "$desktopFile" "$targetFile"
        fi
      '';
    };
}
