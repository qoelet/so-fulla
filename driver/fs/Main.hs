{-# LANGUAGE DeriveDataTypeable, DeriveGeneric #-}

module Main where

import           Data.Typeable
import           GHC.Generics
import           System.Console.GetOpt.Generics
import           System.Environment

import           Fulla
import           PlayList

data Options
  = Options {
      source :: Maybe FilePath
    , playlist :: Maybe FilePath
    , sink :: Maybe String
  }
  deriving (Show, GHC.Generics.Generic)

instance System.Console.GetOpt.Generics.Generic Options
instance HasDatatypeInfo Options

main :: IO ()
main = do
  options <- getArguments
  let mSink = sink options
  case source options of
    Just s -> do
      s' <- readSource s
      (withPulseAudio mSink) (play s')
    Nothing -> do
      case playlist options of
        Just s -> do
          albums <- readPlayList s
          s' <- playListToSource albums
          (withPulseAudio mSink) (play s')
        Nothing -> do
          -- todo: try and look for default playlist in ~/
          putStrLn "nothing to do."
          return ()
