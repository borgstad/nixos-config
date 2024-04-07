{
  description = "NixOS config";

  inputs = {
    # App inputs
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-23.11";
    agenix.url = "github:ryantm/agenix";
    gitwatch.url = "github:gitwatch/gitwatch";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    ssh-keys-andreas = {
      url = "https://github.com/borgstad.keys";
      flake = false;
    };
    ssh-keys-mihi = {
      url = "https://github.com/MihaelaHristov.keys";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, gitwatch, vscode-server, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations =  {
        gimle = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./profiles/gimle.nix
          ];
        };
        muspel = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./profiles/muspel.nix
          ];
        };

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
      };
    };
}
