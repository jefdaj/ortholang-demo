with import ../shortcut/nixpkgs;

# TODO need to add python + shortcut dependencies to the package
# TODO take shortcut, global package set as arguments
# TODO or make shortcut a submodule?

let
  shortcut = import ../shortcut;
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

in stdenv.mkDerivation rec {
  src = ./.;
  version = "0.1";
  name = "shortcut-demo-${version}";
  inherit runDepends;
  buildInputs = [ makeWrapper ] ++ runDepends;
  builder = writeScript "builder.sh" ''
    #!/usr/bin/env bash
    source ${stdenv}/setup
    mkdir -p $out/src
    cp -R $src/templates $src/static $out/src
    mkdir -p $out/bin
    dest="$out/bin/shortcut-demo"
    install -m755 $src/shortcut-demo.py $dest
    wrapProgram $dest --prefix PATH : "${pkgs.lib.makeBinPath runDepends}"
  '';
}
