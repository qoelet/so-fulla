{-# LANGUAGE DeriveGeneric #-}
module PlayList where

import           Control.Applicative
import           Control.Exception
import           Data.Yaml
import           GHC.Generics
import           System.Directory

import           Utils

data Album
  = Album {
      name :: String
    , artist :: String
    , location :: FilePath
    , songs :: Maybe [FilePath]
  } deriving (Eq, Show, Generic)

instance FromJSON Album

readPlayList :: FilePath -> IO [Album]
readPlayList s = do
  r <- decodeFileEither s
  case r of
    Left s -> throwIO $ ErrorCall (prettyPrintParseException s)
    Right albums -> return albums

playListToSource :: [Album] -> IO [FilePath]
playListToSource s = do
  ss <- mapM constructSourcePath s
  return $ concat ss
  where
    constructSourcePath :: Album -> IO [FilePath]
    constructSourcePath Album {location = loc, songs = s}
      = case s of
      Just ss -> return $ map ((loc ++ "/") ++) ss
      Nothing -> do
        ss <- getDirectoryContents loc
        filterDirContents ss
