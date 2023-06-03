{
  description = "NixOS config";

  inputs = {
    # App inputs
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-23.05";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, agenix, vscode-server, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations =  {
        jotunheim = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./profiles/jotunheim.nix
            # How to move this into a seperate file?
            vscode-server.nixosModules.default
            ({ config, pkgs, ... }: {
              services.vscode-server.enable = true;
            })
          ];
        };
        gimle = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./profiles/gimle.nix
          ];
        };
      };
    };
}
