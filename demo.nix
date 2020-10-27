let
  sources   = import ./nix/sources.nix {};
  pkgs      = import sources.nixpkgs {};
  # myHs      = import "${sources.ortholang}/haskell.nix";
  # ortholang = myHs.callPackage sources.ortholang {};
  # docs      = myHs.callPackage (import ./docs.nix) {};
  # docs      = pkgs.callPackage (import ./docs.nix) {};
  myPython  = import ./nix/requirements.nix { inherit pkgs; };
  # TODO pull this from a new blastdbget-nix repo
  # blastdbget = pkgs.pythonPackages.callPackage ./ortholang/nixpkgs/blastdbget {};

# let
  # sources = import ./nix/sources.nix {};
  # pkgs    = import sources.nixpkgs {};
  myHs    = import "${sources.ortholang}/haskell.nix";
# in
  docs = myHs.callCabal2nix "Docs" ./docs { inherit (pkgs) zlib; };

  runDepends = [
    myPython.interpreter
    myPython.packages."Flask"
    myPython.packages."Flask-Misaka"
    myPython.packages."Flask-SocketIO"
    myPython.packages."Flask-Twisted"
    myPython.packages."Pygments"
    myPython.packages."misaka"
    myPython.packages."psutil"
    myPython.packages."pexpect"
    # ortholang
    docs
    # blastdbget
  ];
  binPath = pkgs.lib.makeBinPath runDepends;

in pkgs.stdenv.mkDerivation rec {
  src = ./.;
  version = "0.2";
  name = "ortholang-demo-${version}";
  inherit binPath docs;
  inherit (pkgs) stdenv;
  buildInputs = [ pkgs.makeWrapper ] ++ runDepends;
  builder = ./builder.sh;
}
