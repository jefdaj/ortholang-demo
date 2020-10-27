let
  sources   = import ./nix/sources.nix {};
  pkgs      = import sources.nixpkgs {};
  myHs      = import "${sources.ortholang}/haskell.nix";
  demoDocs  = myHs.callCabal2nix "Docs" ./docs { inherit (pkgs) zlib; };
  myPython  = import ./nix/requirements.nix { inherit pkgs; };

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
    demoDocs
  ];

  binPath = pkgs.lib.makeBinPath runDepends;

in pkgs.stdenv.mkDerivation rec {
  src = ./.;
  version = "0.2";
  name = "ortholang-demo-${version}";
  buildInputs = [ pkgs.makeWrapper ] ++ runDepends;
  builder = ./builder.sh;
  inherit binPath demoDocs;
  inherit (pkgs) stdenv;
}
