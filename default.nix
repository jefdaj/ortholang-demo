with import ../shortcut/nixpkgs;

let
  py = import ./requirements.nix { inherit pkgs; };
  # shortcut = callPackage ../shortcut {};
  runDepends = [ ];

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
