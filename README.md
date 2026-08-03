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
Check the [Home Manager documentatiion](https://home-manager.dev/manual/25.11/index.xhtml#sec-usage-gpu-sudo).

On every `home-manager switch` invocation check the console output for something like

```txt
Activating checkExistingGpuDrivers
GPU drivers require an update, run
  sudo /nix/store/HASH-non-nixos-gpu/bin/non-nixos-gpu-setup
```

and run that `sudo` command, after that it *should* just work <sup>tm</sup>

### Nvidia
Using the Nvidia driver is a little involved, use `nvidia-smi` to check the exact driver version and follow the Home Manager documentation to install it. Be careful when updating the host system as that may change the exact Nvidia driver version being used.

## No user exists for UID ...
This is an issue with using Nix/ Home Manager on a system that uses SSSD to handle authentication. The fix is to manually add `libnss_sss.so.2` to the `LD_PRELOAD` variable.

## Niri
For Niri you must allow whatever user is running `home-manager switch` to write to `/usr/share/wayland-sessions`, to do this, add a narrowly-scoped passwordless sudo rule, e.g. to `/etc/sudoers.d/niri-session-install`:

```
your_username ALL=(root) NOPASSWD: /run/current-system/sw/bin/install -Dm644 * /usr/share/wayland-sessions/niri.desktop
```
