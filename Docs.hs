{-# LANGUAGE QuasiQuotes #-}

module Main where

{- This isn't meant for end users. It's just an easy way to keep
 - the module reference on the website in sync with the actual code.
 -
 - Run the docs binary to update:
 -   templates/reference.md
 -}

import OrthoLang.Core.Types

import Data.List.Split  (splitOn)
import Data.List.Utils  (join)
import OrthoLang.Modules (modules)
import Data.Char        (toLower, isAlphaNum)
import Data.List (nub)
import System.FilePath ((</>), (<.>))
import Paths_OrthoLang             (getDataFileName, version)
import Control.Monad (when)
import System.Directory (doesFileExist)
import NeatInterpolation
import Data.Text (Text, pack, unpack)
import Data.Version (showVersion)

explainType :: OrthoLangType -> String
explainType Empty = error "explain empty type"
explainType (ListOf   t) = explainType t -- TODO add the list part?
explainType (ScoresOf t) = explainType t -- TODO add the scores part?
explainType t = "| " ++ addHelpLink (extOf t) ++ " | " ++ mdEscape (descOf t) ++ " |"

-- TODO these aren't functions!
typesTable :: OrthoLangModule -> [String]
typesTable m = if null (mTypes m) then [""] else
  [ "Types:"
  , ""
  , "| Type      | Meaning |"
  , "| :-------- | :------ |"
  ]
  ++ map explainType (mTypes m)
  ++ [""]

addHelpLink :: String -> String
addHelpLink name =
  "<a href=\"javascript:;\" onclick=\"help_and_scripts('" ++ n ++ "')\">`" ++ name ++ "`</a>"
  where
    n = mdEscape name

mdEscape :: String -> String
mdEscape [] = []
mdEscape (c:cs) = escaped ++ mdEscape cs
  where
    escaped = if c `elem` special then ['\\', c] else [c]
    special = "|"

explainFunction :: OrthoLangFunction -> String
explainFunction = join " | " . cols
  where
    cols f = [addHelpLink $ fName f, quoted $ last $ splitOn ":" $ fTypeDesc f]
    quoted t  = "`" ++ t ++ "`"

functionsTable :: OrthoLangModule -> [String]
functionsTable m = if null (mFunctions m) then [""] else
  [ "Functions:"
  , ""
  , "| Name | Type |"
  , "| :--- | :--- |"
  ]
  ++ map (\f -> "| " ++ explainFunction f ++ " |") (mFunctions m)
  ++ [""]

functionsHeader :: Text -> String
functionsHeader v = unpack [text|
{% import "macros.jinja" as macros with context %}

This is an auto-generated list of the available functions in OrthoLang v$v.

The search box only filters by module. So for example if you search for
"mmseqs", you'll get the MMSeqs module but also BlastHits and ListLike, because
they can use MMSeqs results.

<input id="modulesearch" placeholder="Search the module documentation" id="box" type="text"/>
<br/>

<!-- TODO Why does one extra moduleblock with div + empty line have to go here? -->
<div class="moduleblock">
<div></div>

</div>|]

loadExample :: OrthoLangModule -> [String]
loadExample m = ["{{ macros.load_script(user, 'examples/scripts/" ++ name ++ ".ol') }}"]
  where
    name = filter isAlphaNum $ map toLower $ mName m

-- TODO only use this as default if there's no custom markdown description written?
-- TODO or move that stuff to the tutorial maybe?
moduleReference :: OrthoLangModule -> [String]
moduleReference m =
  [ "<div class=\"moduleblock\">"
  , "<h3>" ++ mName m ++ " module</h3>"
  , ""
  , mDesc m ++ "."
  , ""
  ]
  ++ typesTable m
  ++ functionsTable m
  ++ ["<br/>"]
  ++ loadExample m
  ++ ["</div>"]

-- TODO pick module order to print the reference nicely
writeFunctionsTab :: IO ()
writeFunctionsTab = writeFile "templates/functions.md" $
  functionsHeader (pack $ showVersion version) ++ unlines (concatMap moduleReference modules)

-- this is just for calling manually during development
-- TODO move to Reference.hs?
writeDocPlaceholders :: [OrthoLangModule] -> IO ()
writeDocPlaceholders mods = do
  docs <- getDataFileName "docs"
  mapM_ (writePlaceholder docs) names
  where
    names  = nub $ mNames ++ fNames ++ tNames
    mNames = map (\m -> "modules"   </> mName m) mods
    -- for now, i just create the infix operator docs manually
    fNames = map (\f -> "functions" </> fName f) $ filter (\f -> fFixity f == Prefix) $ concat $ map mFunctions mods
    tNames = map (\t -> "types"     </> extOf t) $ concat $ map mTypes mods

writePlaceholder :: FilePath -> FilePath -> IO ()
writePlaceholder docsDir name = do
  let path = docsDir </> name <.> "txt"
  written <- doesFileExist path
  when (not written) $ do
    putStrLn path
    writeFile path $ "doc for " ++ name ++ " not written yet"

-- TODO take one argument like: ortholang-docs ~/ortholang-demo/templates/reference.md
main :: IO ()
main = do
  writeDocPlaceholders modules
  writeFunctionsTab
