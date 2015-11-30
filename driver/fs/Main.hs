{-# LANGUAGE DeriveGeneric #-}

module Main where

import           Control.Concurrent
import           System.Console.GetOpt.Generics
import           System.IO
import           System.Random
import           System.Random.Shuffle          (shuffle')

import           Control
import           Fulla
import           PlayList

data Options
  = Options {
      source :: Maybe FilePath
    , playlist :: Maybe FilePath
    , sink :: Maybe String
    , shuffle :: Bool
  }
  deriving (Show, Generic)

main :: IO ()
main = do
  writeBanner
  options <- modifiedGetArguments [AddVersionFlag "0.2.2"]
  keyListen <- initKey

  hSetBuffering stdin NoBuffering
  hSetEcho stdin False
  _ <- forkIO $ pollUser keyListen
  let mSink = sink options
      shuff = shuffle options
  case source options of
    Just s -> do
      s' <- readSource s
      case shuff of
        True -> do
          g <- getStdGen
          let rS = shuffle' s' (length s') g
          (withPulseAudio mSink) (play rS keyListen)
        False -> (withPulseAudio mSink) (play s' keyListen)
    Nothing -> do
      case playlist options of
        Just s -> do
          albums <- readPlayList s
          s' <- playListToSource albums
          case shuff of
            True -> do
              g <- getStdGen
              let rS = shuffle' s' (length s') g
              (withPulseAudio mSink) (play rS keyListen)
            False -> (withPulseAudio mSink) (play s' keyListen)
        Nothing -> do
          -- todo: try and look for default playlist in ~/
          putStrLn "nothing to do."
          return ()

writeBanner :: IO ()
writeBanner = do
  let s = "\n \
  \ |~   || _   (~ _|_ oo_|_\n \
  \ |~|_|||(_|  _)(_| ||| | \n "
  putStrLn s
