{-# LANGUAGE QuasiQuotes #-}

-- TODO take an argument for the output dir, and use that in the python build

module Main where

{- This isn't meant for end users. It's just an easy way to keep
 - the module reference on the website in sync with the actual code.
 -
 - Run the docs binary to update:
 -   templates/reference.md
 -}

import OrthoLang.Types
import OrthoLang.Interpreter.Repl.Help

import Data.List.Split  (splitOn)
import Data.List.Utils  (join)
import OrthoLang.Modules (modules)
import Data.Char        (toLower, isAlphaNum)
import Data.List (nub)
import System.FilePath ((</>), (<.>))
import Paths_OrthoLang             (getDataFileName)
import Control.Monad (when)
import System.Directory (doesFileExist, createDirectoryIfMissing)
import System.Environment (getArgs)

explainType :: Type -> String
explainType Empty = error "explain empty type"
explainType (ListOf   t) = explainType t -- TODO add the list part?
explainType (ScoresOf t) = explainType t -- TODO add the scores part?
explainType t = "| " ++ addHelpLink (ext t) ++ " | " ++ mdEscape (desc t) ++ " |"

-- TODO these aren't functions!
typesTable :: Module -> [String]
typesTable m = if null (mTypes m) then [""] else
  [ "Types:"
  , ""
  , "| Name      | Meaning |"
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

-- TODO rewrite to use Repl.Help instead
explainFunction :: Function -> String
explainFunction = join " | " . cols
  where
    cols f = [addHelpLink $ fName f, quoted $ last $ splitOn ":" $ renderSig f]
    quoted t  = "`" ++ t ++ "`"

-- TODO rewrite to use Repl.Help instead?
functionsTable :: Module -> [String]
functionsTable m = if null (mFunctions m) then [""] else
  [ "Functions:"
  , ""
  , "| Name | Type |"
  , "| :--- | :--- |"
  ]
  ++ map (\f -> "| " ++ explainFunction f ++ " |") (mFunctions m)
  ++ [""]

loadExample :: Module -> [String]
loadExample m = ["{{ macros.load_script(user, 'examples/scripts/" ++ name ++ ".ol') }}"]
  where
    name = filter isAlphaNum $ map toLower $ mName m

-- TODO only use this as default if there's no custom markdown description written?
-- TODO or move that stuff to the tutorial maybe?
moduleReference :: Module -> [String]
moduleReference m =
  [ "### " ++ mName m
  , ""
  , mDesc m ++ "."
  , ""
  ]
  ++ typesTable m
  ++ functionsTable m
  ++ ["<br/>"]
  ++ loadExample m

writeModuleReference :: FilePath -> Module -> IO ()
writeModuleReference dir m = do
  createDirectoryIfMissing True dir'
  writeFile path $ unlines $ moduleReference m
  where
    dir' = dir </> "templates"
    path = dir' </> "functions_" ++ mName m ++ ".md"

writeFunctionsTab :: FilePath -> IO ()
-- writeFunctionsTab = writeFile "templates/functions.md" $
--   functionsHeader (pack $ showVersion version) ++ unlines (concatMap moduleReference modules)
writeFunctionsTab dir = do
  createDirectoryIfMissing True dir
  mapM_ (writeModuleReference dir) modules

-- this is just for calling manually during development
-- TODO move to Reference.hs?
writeDocPlaceholders :: [Module] -> FilePath -> IO ()
writeDocPlaceholders mods docsDir = do
  mapM_ (\n -> createDirectoryIfMissing True $ docsDir </> n) ["modules", "functions", "types"]
  mapM_ (writePlaceholder docsDir) names
  where
    names  = nub $ mNames ++ fnames ++ tNames
    mNames = map (\m -> "modules"   </> mName m) mods
    -- for now, i just create the infix operator docs manually
    -- fnames = map (\f -> "functions" </> (head $ fNames f)) $ filter (\f -> fFixity f == Prefix) $ concat $ map mFunctions mods
    fnames = map (\f -> "functions" </> fName f) $ concat $ map mFunctions mods
    tNames = map (\t -> "types"     </> ext t) $ concat $ map mTypes mods

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
  (templatesDir:[]) <- getArgs -- TODO any reason to bother with checks?
  -- writeDocPlaceholders modules docDir
  writeFunctionsTab templatesDir
