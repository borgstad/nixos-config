{
  description = "NixOS config";

  inputs = {
    # App inputs
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "github:nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, ... }:
    let
      systems = [ "x86_64-linux" ];
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in {
      inherit system;
      modules = [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        ./configuration.nix
      ];
      # nixosConfigurations.jotunheim = nixpkgs.lib.nixosSystem {
      #   modules = [
      #     vscode-server.nixosModules.default
      #     ({ config, pkgs, ... }: {
      #       services.vscode-server.enable = true;
      #     })
      #   ];
      # };
    };
}
