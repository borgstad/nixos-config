{
  description = "NixOS config";

  inputs = {
    # App inputs
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "nixpkgs/nixos-23.05";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    ssh-keys = {
      url = "https://github.com/borgstad.keys";
      flake = false;
    };
    sometest.url = "path:/home/surt/code/nixpkgs";
  };

  outputs = inputs@{ self, sometest, nixpkgs, agenix, vscode-server, ... }:
    let
      system = "x86_64-linux";
      customNixpkgs = sometest.legacyPackages.x86_64-linux;
    in {
      nixosConfigurations = {
        gimle = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./profiles/gimle.nix

            # Enable the autobrr service
            ({ pkgs, ... }: {
              services.nginx.enable = true;
              services.autobrr = {
                enable = true;
                openFirewall = true;
              };
            })
          ];
        };

        jotunheim = nixpkgs.lib.nixosSystem {
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
