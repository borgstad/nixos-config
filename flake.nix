{
  description = "NixOS config";

  inputs = {
    # Software inputs
    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit (inputs) self; } {
      systems = [ "x86_64-linux" ];
      flake = {
      };
    };
}
