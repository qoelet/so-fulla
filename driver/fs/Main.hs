{-# LANGUAGE DeriveDataTypeable, DeriveGeneric #-}

module Main where

import           Data.Typeable
import           GHC.Generics
import           System.Console.GetOpt.Generics
import           System.Environment
import           System.Random
import           System.Random.Shuffle (shuffle')

import           Fulla
import           PlayList

data Options
  = Options {
      source :: Maybe FilePath
    , playlist :: Maybe FilePath
    , sink :: Maybe String
    , shuffle :: Bool
  }
  deriving (Show, GHC.Generics.Generic)

instance System.Console.GetOpt.Generics.Generic Options
instance HasDatatypeInfo Options

main :: IO ()
main = do
  options <- getArguments
  let mSink = sink options
      shuff = shuffle options
  case source options of
    Just s -> do
      s' <- readSource s
      case shuff of
        True -> do
          g <- getStdGen
          let rS = shuffle' s' (length s') g
          (withPulseAudio mSink) (play rS)
        False -> (withPulseAudio mSink) (play s')
    Nothing -> do
      case playlist options of
        Just s -> do
          albums <- readPlayList s
          s' <- playListToSource albums
          case shuff of
            True -> do
              g <- getStdGen
              let rS = shuffle' s' (length s') g
              (withPulseAudio mSink) (play rS)
            False -> (withPulseAudio mSink) (play s')
        Nothing -> do
          -- todo: try and look for default playlist in ~/
          putStrLn "nothing to do."
          return ()
