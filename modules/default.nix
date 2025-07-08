{ ... }:
{
  imports = [
    ./vscode/vscode.nix
    ./intellij/intellij.nix
    ./tmux/tmux.nix
    ./fish/fish.nix
    ./alacritty/alacritty.nix
    ./devenv/devenv.nix
    ./gitCommands/gitCommands.nix
  ];
}
