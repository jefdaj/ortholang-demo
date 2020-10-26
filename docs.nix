let
  sources = import ./nix/sources.nix {};
  pkgs    = import sources.nixpkgs {};
  myHs    = import "${sources.ortholang}/haskell.nix";
in
  myHs.callCabal2nix "Docs" ./docs { inherit (pkgs) zlib; }
