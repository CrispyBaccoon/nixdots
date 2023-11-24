{
  nixpkgs,
  inputs,
  ...
}: let
  inherit (nixpkgs) lib;

  services = import ./services.nix {inherit lib;};
in
  nixpkgs.lib.extend (_: _: services)
