module Main where

{- This isn't meant for end users. It's just an easy way to keep
 - the module reference on the website in sync with the actual code.
 - Run shortcut --reference to generate an updated templates/reference.md
 -
 - TODO put in a separate binary?
 -}

import ShortCut.Core.Types

import Data.List.Split  (splitOn)
import Data.List.Utils  (join)
import ShortCut.Modules (modules)
import Data.Char        (toLower, isAlphaNum)
import Data.List (nub)
import System.FilePath ((</>), (<.>))
import Paths_ShortCut             (getDataFileName)
import Control.Monad (when)
import System.Directory (doesFileExist)


explainType :: CutType -> String
explainType Empty = error "explain empty type"
explainType (ListOf   t) = explainType t -- TODO add the list part?
explainType (ScoresOf t) = explainType t -- TODO add the scores part?
explainType t = "| `" ++ extOf t ++ "` | " ++ descOf t ++ " |"

-- TODO these aren't functions!
typesTable :: CutModule -> [String]
typesTable m = if null (mTypes m) then [""] else
  [ "Types:"
  , ""
  , "| Type      | Meaning |"
  , "| :-------- | :------ |"
  ]
  -- ++ map (\f -> "| " ++ fName f ++ " | " ++ (fromMaybe "" $ fDesc f) ++ " |") (mFunctions m)
  -- ++ map (\f -> "| " ++ fName f ++ " | " ++ "" ++ " |") (mFunctions m)
  ++ map explainType (mTypes m)
  ++ [""]

explainFunction :: CutFunction -> String
explainFunction = join " | " . barred . map quoted . elems
  where
    elems  f  = filter (not . (`elem` [":", "->"])) $ splitOn " " $ fTypeDesc f
    barred es = [head es, join ", " $ init $ tail es, last es]
    quoted t  = "`" ++ t ++ "`"

functionsTable :: CutModule -> [String]
functionsTable m = if null (mFunctions m) then [""] else
  [ "Functions:"
  , ""
  , "| Name | Inputs | Output |"
  , "| :--- | :----- | :----- |"
  ]
  ++ map (\f -> "| " ++ explainFunction f ++ " |") (mFunctions m)
  ++ [""]

header :: [String]
header =
 [ "{% import \"macros.jinja\" as macros with context %}"
 , ""
 , "<input id=\"modulesearch\" placeholder=\"Search the module documentation\" id=\"box\" type=\"text\"/>"
 , ""
 , "If you don't find what you're looking for, leave Jeff a comment about it! (bottom right)"
 , "<br/>"
 , ""
 ]

loadExample :: CutModule -> [String]
loadExample m = ["{{ macros.load_cut(user, 'examples/" ++ name ++ ".cut') }}"]
  where
    name = filter isAlphaNum $ map toLower $ mName m

-- TODO only use this as default if there's no custom markdown description written?
-- TODO or move that stuff to the tutorial maybe?
moduleReference :: CutModule -> [String]
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
writeReference :: IO ()
writeReference = writeFile "templates/reference.md" $ unlines $
  header ++
  concatMap moduleReference modules

-- this is just for calling manually during development
-- TODO move to Reference.hs?
writeDocPlaceholders :: [CutModule] -> IO ()
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

-- TODO take one argument like: shortcut-docs ~/shortcut-demo/templates/reference.md
main :: IO ()
main = do
  writeDocPlaceholders modules
  writeReference
