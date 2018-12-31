with import ../detourrr/nixpkgs;

# TODO need to add python + detourrr dependencies to the package
# TODO take detourrr, global package set as arguments
# TODO or make detourrr a submodule?

let
  detourrr = import ../detourrr;
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
    detourrr
  ];

in stdenv.mkDerivation rec {
  src = ./.;
  version = "0.1";
  name = "detourrr-demo-${version}";
  inherit runDepends;
  buildInputs = [ makeWrapper ] ++ runDepends;
  builder = writeScript "builder.sh" ''
    #!/usr/bin/env bash
    source ${stdenv}/setup
    mkdir -p $out/src
    cp -R $src/templates $src/static $out/src
    mkdir -p $out/bin
    dest="$out/bin/detourrr-demo"
    install -m755 $src/detourrr-demo.py $dest
    wrapProgram $dest --prefix PATH : "${pkgs.lib.makeBinPath runDepends}"
  '';
}
