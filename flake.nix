{
  description = "NixOS config";

  inputs = {
    # Software inputs
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    # nixos-vscode-server.flake = false;
    # emanote.url = "github:srid/emanote";
    # nixpkgs-match.url = "github:srid/nixpkgs-match";
    # nuenv.url = "github:DeterminateSystems/nuenv";
    # devour-flake.url = "github:srid/devour-flake";
    # devour-flake.flake = false;
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit (inputs) self; } {
      systems = [ "x86_64-linux" ];
      # imports = [
      #   inputs.nixos-flake.flakeModule
      #   ./users
      #   ./home
      #   ./nixos
      # ];

      flake = {
        # Configurations for Linux (NixOS) systems
        # nixosConfigurations = {
        #   actual = self.nixos-flake.lib.mkLinuxSystem {
        #     imports = [
        #       self.nixosModules.default # Defined in nixos/default.nix
        #       inputs.sops-nix.nixosModules.sops
        #       ./systems/hetzner/ex101.nix
        #       ./nixos/server/harden.nix
        #       ./nixos/docker.nix
        #       ./nixos/jenkins.nix
        #     ];
        #     services.tailscale.enable = true;
        #     sops.defaultSopsFile = ./secrets.json;
        #     sops.defaultSopsFormat = "json";
        #   };
        # }
        ;

        # Configurations for my (only) macOS machine (using nix-darwin)
        # darwinConfigurations = {
        #   appreciate = self.nixos-flake.lib.mkARMMacosSystem {
        #     imports = [
        #       self.darwinModules.default # Defined in nix-darwin/default.nix
        #       ./nixos/hercules.nix
        #       ./systems/darwin.nix
        #     ];
        #   };
        };
      };

      perSystem = { self', system, pkgs, lib, config, inputs', ... }: {
        # _module.args.pkgs = import inputs.nixpkgs {
        #   # inherit system;
        #   # overlays = [
        #   #   inputs.jenkins-nix-ci.overlay
        #   # ];
        # };
        packages.default = self'.packages.activate;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            # pkgs.sops
            # pkgs.ssh-to-age
            # (
            #   let nixosConfig = self.nixosConfigurations.actual;
            #   in nixosConfig.config.jenkins-nix-ci.nix-prefetch-jenkins-plugins pkgs
            # )
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
