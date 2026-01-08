{
  description = "Home Manager configuration of fuju";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixgl,
      nix-vscode-extensions,
      ...
    }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixgl.overlay
          nix-vscode-extensions.overlays.default

          (final: prev: {
            my-alacritty = prev.alacritty.overrideAttrs (oldAttrs: rec {
              version = "0.17.0-dev";

              src = pkgs.fetchFromGitHub {
                owner = "MindSwipe";
                repo = "alacritty";
                rev = "93591bcee2f1c0a2d17abdfd59bba59812b6e2e0";
                hash = "sha256-zaZ0eY/VBX169BCoh/TODdAEzet0aPAg8jc1oST6Eqk=";
              };

              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit src;
                hash = "sha256-2ikO7dyzIG9GcUrLeaKpn1ilLUldhiXuvYGo/WpUW3Q=";
              };
            });
          })
        ];
      };
      username = "fuju";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit nixgl username;
        };
      };
    };
}
