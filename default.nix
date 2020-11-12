let
  sources   = import ./nix/sources.nix {};
  pkgs      = import sources.nixpkgs {};
  myHs      = import "${sources.ortholang}/haskell.nix";
  demoDocs  = myHs.callCabal2nix "Docs" ./docs { inherit (pkgs) zlib; };

  # nixpkgs is deprecating python2, so to keep the website working i pin a
  # separate old version of nixpkgs and use old interpreter + pypi2nix to
  # update individual python packages.
  pkgsOld   = import sources.nixpkgsOld {};
  myPython  = import ./nix/requirements.nix { pkgs=pkgsOld; };

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
