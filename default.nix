with import ./shortcut/nixpkgs;

# TODO need to add python + shortcut dependencies to the package
# TODO take shortcut, global package set as arguments
# TODO or make shortcut a submodule?

let
  # fetch my pinned nixpkgs for reproducibility.
  # use this instead to try to build it with your system's current nixpkgs:
  # pkgs = import <nixpkgs> {};
  # to update the the sha256sum, use nix-prefetch-url --unpack
  # (see https://github.com/NixOS/nix/issues/1381#issuecomment-300755992)
  pkgs = import (fetchTarball {
    url = "https://github.com/jefdaj/nixpkgs/archive/2019-03-20_nixpkgs-shortcut.tar.gz";
    sha256 = "1lj3paw9z0n8v1dk8nxmnd7i0z209746cyz19vsadkswd87x7ipm";
  }) {};

  shortcut = import ./shortcut;
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
    shortcut
  ];

in pkgs.stdenv.mkDerivation rec {
  src = ./.;
  version = "0.1";
  name = "shortcut-demo-${version}";
  inherit runDepends;
  buildInputs = [ pkgs.makeWrapper ] ++ runDepends;
  builder = pkgs.writeScript "builder.sh" ''
    #!/usr/bin/env bash
    source ${pkgs.stdenv}/setup
    mkdir -p $out/src
    cp -R $src/templates $src/static $out/src
    mkdir -p $out/bin
    dest="$out/bin/shortcut-demo"
    install -m755 $src/shortcut-demo.py $dest
    wrapProgram $dest --prefix PATH : "${pkgs.lib.makeBinPath runDepends}"
  '';
}
