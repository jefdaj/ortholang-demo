# with import ./ortholang/nixpkgs;

# TODO AHA! TRY GHCWITHPACKAGES INSTEAD OF THIS STUFF

let
  sources   = import ./nix/sources.nix {};
  pkgs      = import sources.nixpkgs {};

   # working:
  # progress-meter = haskell.lib.doJailbreak
  #   (haskell.lib.overrideCabal haskellPackages.progress-meter (drv: {
  #     broken = false;
  #   })); 

  # working:
  # OrthoLang = haskellPackages.callPackage ./ortholang/ortholang.nix {
  #   inherit progress-meter;
  # };

  # working:
  # OrthoLang = import ./ortholang;

  # not working:
  # docs2 = haskellPackages.callPackage ./docs2.nix { inherit progress-meter OrthoLang; };
  # docs = haskell.lib.addBuildDepends docs2
  #   (with haskellPackages; [
  #     zlib
  #     zlib.dev
  #     zlib.out
  #     pkgconfig
  #   ]);
  # noBigDotfiles = path: type: baseNameOf path != ".stack-work"
  #                          && baseNameOf path != ".git";

  # myGHC = pkgs.haskell.packages.ghc884;
  # logging = myGHC.callPackage (import ./ortholang/logging) {};
  # progress-meter = haskell.lib.overrideCabal pkgs.haskellPackages.progress-meter (_: {
  #   broken = false;
  #   jailbreak = true;
  # });

  # docopt    = myGHC.callPackage sources.docopt {};
  # OrthoLang = myGHC.callPackage sources.ortholang {};

# in haskellPkg
# in OrthoLang

  inherit (pkgs.haskell.lib) overrideCabal dontCheck;
  myGHC = "ghc884";
  myHs = pkgs.haskell.packages.${myGHC}.override {
    overrides = hpNew: hpOld: rec {

      # Packages that can be fixed with simple overrides
      # TODO try on hpc: unliftio = dontCheck hpOld.unliftio;
      # TODO try on hpc: unliftio = hpNew.callHackage "unliftio" "0.2.12.1" {};
      progress-meter = overrideCabal hpOld.progress-meter (_: {
        broken = false;
        jailbreak = true;
      });

      # Packages that had to be forked
      # logging = hpNew.callPackage sources.logging {};
      docopt  = hpNew.callPackage sources.docopt {};

      # The ortholang package, which includes the main binary
      # TODO final wrapper with +RTS -N -RTS?
      # TODO get back the enable{Library,Executable}Profiling options?
      # ortholang = hpNew.callPackage sources.docopt {};
      OrthoLang = hpNew.callPackage
                    # (hpNew.callCabal2nix "OrthoLang" sources.OrthoLang {})
                    sources.OrthoLang
                    {};

      # OrthoLangDocsTmp = hpNew.callPackage (hpNew.callCabal2nix "Docs" ./docs {}) {}; # {
      # OrthoLangDocsTmp = hpNew.callPackage (hpNew.callCabal2nix "Docs" ./docs {}) {}; # {
        # inherit OrthoLang;
        # inherit logging progress-meter OrthoLang;
      # };
      OrthoLangDocs = pkgs.haskell.lib.overrideCabal (hpNew.callCabal2nix "Docs" ./docs {}) (drv: {
        # src = builtins.filterSource noBigDotfiles ./.;
        buildDepends = (drv.buildDepends or [])  ++ [
          pkgs.zlib.dev pkgs.zlib.out pkgs.pkgconfig
        ];
      });


#       OrthoLangDocs = overrideCabal (hpNew.callCabal2nix "Docs" ./docs {}) (drv: {
# 
#         # surprisingly, this works as a drop-in replacement for filterSource
#         # except with better filtering out of non-source files
#         # based on https://github.com/NixOS/nix/issues/885#issuecomment-381904833
#         src = builtins.fetchGit { url = ./.; }; # TODO ./docs?
# 
# #         shellHook = ''
# #           ${drv.shellHook or ""}
# #           export LANG=en_US.UTF-8
# #           export LANGUAGE=en_US.UTF-8
# #           # export TASTY_HIDE_SUCCESSES=True
# #         '' ++
# #         (if stdenv.hostPlatform.system == "x86_64-darwin" then "" else ''
# #           export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
# #         '');
# 
#       });

    };
  };

in {

  # This is the main build target for default.nix
  project = myHs.OrthoLangDocs;

  # And this is the development environment for shell.nix
  # Most of the shell stuff is here, but shellHook above is also important
  shell = myHs.shellFor {

    # TODO would there be any reason to add other packages here?
    packages = p: with p; [ myHs.OrthoLangDocs ];

    # Put any packages you want during development here.
    # You can optionally go "full reproducible" by adding your text editor
    # and using `nix-shell --pure`, but you'll also have to add some common
    # unix tools as you go.
    buildInputs = with myHs; [
      # ghcid
      # hlint
      # stack
    ];

    # Run a local Hoogle instance like this:
    # nix-shell --run hoogle server --port=8080 --local --haskell
    withHoogle = true;
  };
}
