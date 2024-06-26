{
  description = "NixOS config";

  inputs = {
    # App inputs
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    gitwatch.url = "github:borgstad/gitwatch/fix/nix-flake";
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

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, agenix, gitwatch, vscode-server, ... }:
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
          ] ++ gitwatch.modules;
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
