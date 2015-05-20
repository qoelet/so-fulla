module Utils where

filterDirContents :: [FilePath] -> IO [FilePath]
filterDirContents = return . (filter (/= ".")) . (filter (/= ".."))
