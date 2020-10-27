let
  sources   = import ./nix/sources.nix {};
  pkgs      = import sources.nixpkgs {};
  # myHs      = import "${sources.ortholang}/haskell.nix";
  # ortholang = myHs.callPackage sources.ortholang {};
  # docs      = myHs.callPackage (import ./docs.nix) {};
  docs      = import ./docs.nix;
  myPython  = import ./nix/requirements.nix { inherit pkgs; };
  # TODO pull this from a new blastdbget-nix repo
  # blastdbget = pkgs.pythonPackages.callPackage ./ortholang/nixpkgs/blastdbget {};

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
    cp -R $src/templates $src/static $src/data $out/src
    mkdir -p $out/bin
    dest="$out/bin/ortholang-demo"
    install -m755 $src/ortholang-demo.py $dest
    wrapProgram $dest --prefix PATH : "${pkgs.lib.makeBinPath runDepends}"
    cd $src
    python scripts/prefetch.py > $out/data/prefetch.ol
    ${docs}/bin/docs /tmp/rmthis $out/templates
  '';
}
