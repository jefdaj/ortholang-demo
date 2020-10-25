let
  sources        = import ./nix/niv-sources.nix {};
  pkgs           = import sources.nixpkgs {};
  ortholang      = import sources.ortholang {};
  ortholang-docs = null;
  ortholang-data = null;
  ortholang-demo = pkgs.callPackage ./default.nix {};
in
  ortholang-demo
