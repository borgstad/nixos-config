{ inputs, config, lib, pkgs, ... }:
let
  inherit (inputs) vscode-server;
in
{
  environment.systemPackages = with pkgs; [ nodejs ];

  imports = [
    vscode-server.nixosModules.default
  ];
  services.vscode-server.enable = true;
  # services.vscode-server.enableFHS = true;
  # services.vscode-server.nodejsPackage = pkgs.nodejs_18;
}
