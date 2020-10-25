with import ./ortholang/nixpkgs;

let
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
  OrthoLang = import ./ortholang;

  # not working:
  # docs2 = haskellPackages.callPackage ./docs2.nix { inherit progress-meter OrthoLang; };
  # docs = haskell.lib.addBuildDepends docs2
  #   (with haskellPackages; [
  #     zlib
  #     zlib.dev
  #     zlib.out
  #     pkgconfig
  #   ]);
  noBigDotfiles = path: type: baseNameOf path != ".stack-work"
                           && baseNameOf path != ".git";

  myGHC = pkgs.haskell.packages.ghc865;
  logging = myGHC.callPackage (import ./ortholang/logging) {};
  progress-meter = haskell.lib.overrideCabal pkgs.haskellPackages.progress-meter (_: {
    broken = false;
    jailbreak = true;
  });
  haskellPkg = myGHC.callCabal2nix "Docs" ./docs-generated.nix {
    inherit logging progress-meter OrthoLang;
  };
  docs = haskell.lib.overrideCabal haskellPkg (drv: {
    src = builtins.filterSource noBigDotfiles ./.;
    buildDepends = (drv.buildDepends or [])  ++ [
      zlib.dev zlib.out pkgconfig
    ];
  });

in docs
