module Utils where

import           Data.List

filterDirContents :: [FilePath] -> IO [FilePath]
filterDirContents = return . filter isPlayable . filter (/= ".") . filter (/= "..")

isPlayable :: FilePath -> Bool
isPlayable s = "flac" `isSuffixOf` s' || "wav" `isSuffixOf` s'
  where
    s' = (reverse . take 5 . reverse) s
