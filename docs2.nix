# with import ./ortholang/nixpkgs;

# TODO AHA! TRY GHCWITHPACKAGES INSTEAD OF THIS STUFF

# TODO ok, troubleshooting clues...
# shell works with no packages or docopt, but try OrthoLang -> attempt to call a set

let
  sources   = import ./nix/sources.nix {};
  pkgs      = import sources.nixpkgs {};
  # inherit (pkgs.haskell.lib) overrideCabal dontCheck;
  # myGHC = "ghc884";
  myHs = import "${sources.ortholang}/haskell.nix";
  # myHs2 = myHs // rec {
    # overrides = hpNew: hpOld: {
      # ortholang = hpOld.ortholang;
      # OrthoLang = hpNew.OrthoLang;
  # OrthoLangDocs = myHs.callCabal2nix "Docs" ./docs {};
  docs = myHs.callPackage ./docs { inherit (pkgs) zlib; };
    # };
  # };
#   myHs = pkgs.haskell.packages.${myGHC}.override {
#     overrides = hpNew: hpOld: rec {
# 
#       # Packages that can be fixed with simple overrides
#       # TODO try on hpc: unliftio = dontCheck hpOld.unliftio;
#       # TODO try on hpc: unliftio = hpNew.callHackage "unliftio" "0.2.12.1" {};
#       progress-meter = overrideCabal hpOld.progress-meter (_: {
#         broken = false;
#         jailbreak = true;
#       });
# 
#       # Packages that had to be forked
#       logging = hpNew.callPackage sources.logging {};
#       docopt  = hpNew.callPackage sources.docopt {};
# 
#       # The ortholang package, which includes the main binary
#       # TODO final wrapper with +RTS -N -RTS?
#       # TODO get back the enable{Library,Executable}Profiling options?
#       # ortholang = hpNew.callPackage sources.docopt {};
#       OrthoLang = hpNew.callPackage sources.ortholang { inherit (pkgs) zlib; };
#       # OrthoLang = hpNew.callPackage ../ortholang {};
#       # OrthoLang = hpNew.callPackage (builtins.fetchGit { url = ../ortholang; }) {};
# 
#       # OrthoLangDocsTmp = hpNew.callPackage (hpNew.callCabal2nix "Docs" ./docs {}) {}; # {
#       # OrthoLangDocsTmp = hpNew.callPackage (hpNew.callCabal2nix "Docs" ./docs {}) {}; # {
#         # inherit OrthoLang;
#         # inherit logging progress-meter OrthoLang;
#       # };
# #       OrthoLangDocs = pkgs.haskell.lib.overrideCabal (hpNew.callCabal2nix "Docs" ./docs {}) (drv: {
# #         # src = builtins.filterSource noBigDotfiles ./.;
# #         buildDepends = (drv.buildDepends or [])  ++ [
# #           pkgs.zlib.dev pkgs.zlib.out pkgs.pkgconfig
# #         ];
# #       });
# 
# 
# #       OrthoLangDocs = overrideCabal (hpNew.callCabal2nix "Docs" ./docs {}) (drv: {
# # 
# #         # surprisingly, this works as a drop-in replacement for filterSource
# #         # except with better filtering out of non-source files
# #         # based on https://github.com/NixOS/nix/issues/885#issuecomment-381904833
# #         src = builtins.fetchGit { url = ./.; }; # TODO ./docs?
# # 
# # #         shellHook = ''
# # #           ${drv.shellHook or ""}
# # #           export LANG=en_US.UTF-8
# # #           export LANGUAGE=en_US.UTF-8
# # #           # export TASTY_HIDE_SUCCESSES=True
# # #         '' ++
# # #         (if stdenv.hostPlatform.system == "x86_64-darwin" then "" else ''
# # #           export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
# # #         '');
# # 
# #       });
# 
#     };
#   };

# in pkgs.stdenv.mkDerivation {
#   name = "test";
#   buildInputs = [ myHs.ghcWithPackages (ps: [ ps.ortholang ] ) ];
# }
# in {
# # 
# #   # This is the main build target for default.nix
#   project = docs;
# # 
#   # And this is the development environment for shell.nix
#   # Most of the shell stuff is here, but shellHook above is also important
#   shell = myHs.shellFor {
# 
#     # TODO would there be any reason to add other packages here?
#     packages = p: with p; [
#       # docopt
#       docs
#       # fails: OrthoLangDocs
#     ];
# 
#     # Put any packages you want during development here.
#     # You can optionally go "full reproducible" by adding your text editor
#     # and using `nix-shell --pure`, but you'll also have to add some common
#     # unix tools as you go.
#     buildInputs = with myHs; [
#       ghcid
#       hlint
#       stack
#     ];
# 
#     # Run a local Hoogle instance like this:
#     # nix-shell --run hoogle server --port=8080 --local --haskell
#     withHoogle = true;
#   };
# }

in docs
