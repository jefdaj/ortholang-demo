with import ./shortcut/nixpkgs;

let
  shortcut = import ./shortcut/default.nix;

in haskell.lib.overrideCabal shortcut (drv: {
  buildDepends = drv.buildDepends ++ [stack];
  shellHook = ''
    ${drv.shellHook or ""}
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8
  '' ++
  (if stdenv.hostPlatform.system == "x86_64-darwin" then "" else ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '');

})
