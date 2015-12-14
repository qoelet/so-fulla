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
  case isFile of
    True -> return [s]
    False -> do
      isDir <- doesDirectoryExist s
      case isDir of
        True -> getDirectoryContents s >>= filterDirContents >>= return . sort . map ((s ++ "/") ++)
        False -> return []

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
          case playNext of
            True -> return ()
            False -> do
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
    Nothing
    "so-fulla"
    Play
    sink'
    "play on the Fulla!"
    (SampleSpec (F32 LittleEndian) 44100 2)
    Nothing
    Nothing
  where
    sink' = case sink of
      Nothing -> Just "alsa_output.usb-Schiit_Audio_I_m_Fulla_Schiit-00-Schiit.analog-stereo"
      Just s -> Just s

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
