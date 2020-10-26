let
  sources = import ./nix/sources.nix {};
  pkgs    = import sources.nixpkgs {};
  myHs    = import "${sources.ortholang}/haskell.nix";
in
  myHs.callPackage ./docs { inherit (pkgs) zlib; }
