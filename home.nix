{
  config,
  pkgs,
  nixgl,
  username,
  ...
}:

let
  unfree = [
    "vscode"
    "idea"
  ];
in
{
  imports = [
    ./modules
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fuju";
  home.homeDirectory = "/home/fuju";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    neofetch
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fuju/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".ssh/allowed_signers".source = ./assets/allowed_signers;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Juri Furer";
        email = "juri.furer@dvbern.ch";
      };
    };

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = (
    pkg: builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
  );

  targets.genericLinux.nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
  };

  modules.vscode = {
    enable = true;
    nix.enable = true;
    js.enable = true;
    fish.enable = true;
    dmn.enable = true;
    slint.enable = true;
    rust.enable = true;
    wgsl.enable = true;
    vue.enable = true;
  };

  modules.intellij = {
    enable = true;
    mvnd = false;
    wildfly.enable = true;
  };

  modules.tmux = {
    enable = true;
  };

  modules.fish = {
    enable = true;
    sssd.uses = true;
  };

  modules.alacritty = {
    enable = true;
  };

  modules.devenv = {
    enable = true;
  };

  modules.gitCommands = {
    enable = true;
  };

  modules.geany = {
    enable = true;
  };

  modules.bruno = {
    enable = true;
  };

  modules.gpaste = {
    enable = true;
  };

  modules.openshift = {
    enable = true;
  };

  modules.kubectl = {
    enable = true;
  };

  modules.treefmt = {
    enable = true;
  };
}
