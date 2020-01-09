let
  # fetch my pinned nixpkgs for reproducibility
  # (ortholang-linux, dervived from nixpkgs-channels/nixos-19.09)
  pkgs = let inherit (import <nixpkgs> {}) stdenv fetchFromGitHub; in import (fetchFromGitHub {
    owner  = "jefdaj";
    repo   = "nixpkgs";
    rev    = "89520e692736b1e7fc3926bbd52c4e1faaa16eb9";
    sha256 = "1vv5ydpckhsck5bm45hvlvbvn2nlxv2mpnqb82943p7vkwk87shy";
  }) {};
  # use this instead to try to build it with your system's current nixpkgs:
  # pkgs = import <nixpkgs> {};

  ortholang = import ./ortholang;
  myPython = import ./requirements.nix { inherit pkgs; };

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
    ortholang
  ];

in pkgs.stdenv.mkDerivation rec {
  src = ./.;
  version = "0.1";
  name = "ortholang-demo-${version}";
  inherit runDepends;
  buildInputs = [ pkgs.makeWrapper ] ++ runDepends;
  builder = pkgs.writeScript "builder.sh" ''
    #!/usr/bin/env bash
    source ${pkgs.stdenv}/setup
    mkdir -p $out/src
    cp -R $src/templates $src/static $out/src
    mkdir -p $out/bin
    dest="$out/bin/ortholang-demo"
    install -m755 $src/ortholang-demo.py $dest
    wrapProgram $dest --prefix PATH : "${pkgs.lib.makeBinPath runDepends}"
  '';
}
