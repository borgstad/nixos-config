{
  description = "NixOS config";

  inputs = {
    # App inputs
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      # systems = [ "x86_64-linux" ];
      system = "x86_64-linux"
      lib = nixpkgs.lib;
    in {
      nixosConfigurations =  {
        jotunheim = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
