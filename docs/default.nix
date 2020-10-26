{ mkDerivation, ansi-terminal, base, bytestring, concurrent-extra
, configurator, containers, cryptohash, data-default-class
, directory, dlist, download, filelock, filepath, Glob, haskeline
, hspec, logging, MissingH, mtl, neat-interpolation, OrthoLang
, parsec, path, path-io, posix-escape, pretty, process
, progress-meter, QuickCheck, random, random-shuffle
, raw-strings-qq, regex-compat, regex-posix, retry, safe-exceptions
, scientific, setlocale, shake, silently, split, stdenv, strict
, tasty, tasty-golden, tasty-hspec, tasty-hunit, tasty-quickcheck
, temporary, terminal-size, text, time, transformers
, unbounded-delays, unix, utility-ht, zlib
}:
mkDerivation {
  pname = "Docs";
  version = "0.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal base bytestring concurrent-extra configurator
    containers cryptohash data-default-class directory dlist download
    filelock filepath Glob haskeline hspec logging MissingH mtl
    neat-interpolation OrthoLang parsec path path-io posix-escape
    pretty process progress-meter QuickCheck random random-shuffle
    raw-strings-qq regex-compat regex-posix retry safe-exceptions
    scientific setlocale shake silently split strict tasty tasty-golden
    tasty-hspec tasty-hunit tasty-quickcheck temporary terminal-size
    text time transformers unbounded-delays unix utility-ht
  ];
  executablePkgconfigDepends = [ zlib ];
  description = "Partial automation for updating the ortholang-demo docs";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
