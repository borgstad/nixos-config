{
  description = "NixOS config";

  inputs = {
    # App inputs
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-22.11";
  };

  outputs = inputs@{ self, nixpkgs, vscode-server, ... }:
    let
      # systems = [ "x86_64-linux" ];
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
      };
    };
}
