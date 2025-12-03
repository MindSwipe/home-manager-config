# My Home Manager config

Things I want to do here:

* [ ] Make it multi-user/ multi-machine compatible
* [ ] Integrate it into [my NixOS config](https://github.com/MindSwipe/nix-config) (after that has been reworked)

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

## No user exists for UID ...
This is an issue with using Nix/ Home Manager on a system that uses SSSD to handle authentication. The fix is to manually add `libnss_sss.so.2` to the `LD_PRELOAD` variable.