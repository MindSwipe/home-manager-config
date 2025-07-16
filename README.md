# My Home Manager config

## Electron/ SUID Sandbox issues
Create an apparmor rule in /etc/apparmor.d analogous to the nix-vscode or nix-bruno rule ensuring the path is correct (i.e. something like /nix/store/*-bruno-*/**/*), something like this:

```apparmor
include <tunables/global>

profile nix-vscode /nix/store/*-vscode-*/**/* flags=(default_allow) {
  userns,
}
```

After that, reload the specific apparmor profile or all with either

    sudo apparmor_parser -r /etc/apparmor.d/nix-vscode

or

    sudo systemctl reload apparmor.service

## OpenGL/ Hardware acceleration

Use the `config.lib.nixGL.wrap` to wrap any package like `(config.lib.nixGL.wrap pkgs.alacritty)`