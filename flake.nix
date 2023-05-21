{
  description = "NixOS config";

  inputs = {
    # App inputs
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };

  outputs = inputs@{ self, ... }:
    let
      systems = [ "x86_64-linux" ];
    in {

      nixosConfiguration = {
        inherit systems inputs;
      modules = [
        ./configuration.nix
        ./profiles/jotunheim.nix
        ];
      };
    }
}
