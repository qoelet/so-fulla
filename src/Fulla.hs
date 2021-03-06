{-# LANGUAGE ScopedTypeVariables #-}

module Fulla where

import           Control.Exception
import           Data.List
import           System.Directory
import           System.Exit

import qualified Data.Vector.Generic              as V
import qualified Sound.File.Sndfile               as SF
import qualified Sound.File.Sndfile.Buffer.Vector as BV
import           Sound.Pulse.Simple

import           Control
import           Utils

readSource :: FilePath -> IO [FilePath]
readSource s = do
  isFile <- doesFileExist s
  if isFile
    then return [s]
    else do
      isDir <- doesDirectoryExist s
      if isDir
        then
          sort . map ((s ++ "/") ++)
          <$> (
            getDirectoryContents s
            >>= filterDirContents)
        else
          throwIO $ ErrorCall "file does not exist!"

play :: [FilePath] -> KeyListen -> Simple -> IO ()
play [] _ _ = return ()
play (x:xs) key conn = do
  withAudioFile x $ \ h -> playS h conn key
  play xs key conn

playS :: SF.Handle -> Simple -> KeyListen -> IO ()
playS h conn key = do
  -- how do I stream the file ?
  mFrames <- streamFlac h
  case mFrames of
    Just frames -> do
      quitFs <- quit key
      if quitFs
        then exitSuccess
        else do
          playNext <- nextSong key
          if playNext
            then pure ()
            else do
              simpleWrite conn frames
              playS h conn key
    Nothing -> return ()

streamFlac :: SF.Handle -> IO (Maybe [Float])
streamFlac h = do
  mStream <- SF.hGetBuffer h 44100
  case mStream of
    Nothing -> return Nothing
    Just (buffy :: BV.Buffer Float) -> do
      let flacS = V.toList $ BV.fromBuffer buffy
      return (Just flacS)

connectPulseAudio :: Maybe String -> IO Simple
connectPulseAudio sink
  = simpleNew
    Nothing -- server name
    "so-fulla" -- client name
    Play
    sink
    "a minimal commandline music player" -- client description
    (SampleSpec (F32 LittleEndian) 44100 2)
    Nothing -- channel position
    Nothing -- buffer attributes

closePulseAudio :: Simple -> IO ()
closePulseAudio conn = do
  simpleDrain conn
  simpleFree conn

withPulseAudio :: Maybe String -> (Simple -> IO ()) -> IO ()
withPulseAudio s = bracket (connectPulseAudio s) closePulseAudio

readAudioFile :: FilePath -> IO SF.Handle
readAudioFile s = do
  info <- SF.getFileInfo s
  putStrLn $ "now playing: " ++ s
  writeAudioFileInfo info
  SF.openFile s SF.ReadMode info

writeAudioFileInfo :: SF.Info -> IO ()
writeAudioFileInfo info = do
  let sampleRate = SF.samplerate info
      numFrames = SF.frames info
      durationMin = (numFrames `div` sampleRate) `div` 60
      durationSec = (numFrames `div` sampleRate) `rem` 60
  putStrLn $ "length: " ++ show durationMin ++ ":" ++ show durationSec

withAudioFile :: FilePath -> (SF.Handle -> IO()) -> IO ()
withAudioFile s = bracket (readAudioFile s) SF.hClose
