# My Home Manager config

## Electron/ SUID Sandbox issues
On computers with AppArmor it may happen that starting an Electron application/ a binary with the SUID bit fails. This is a known issue, see [#121694](https://github.com/NixOS/nixpkgs/issues/121694). The following is what I used to fix it on Ubuntu 24.04:

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