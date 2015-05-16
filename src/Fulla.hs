{-# LANGUAGE ScopedTypeVariables #-}

module Fulla where

import           Control.Exception
import qualified Data.Vector.Generic              as V
import qualified Sound.File.Sndfile               as SF
import qualified Sound.File.Sndfile.Buffer.Vector as BV
import           Sound.Pulse.Simple
import           Sound.Pulse.Simple

playFlac :: FilePath -> Simple -> IO ()
playFlac fp conn = do
  (info, Just (buffy :: BV.Buffer Float)) <- SF.readFile fp
  let flac = V.toList $ BV.fromBuffer buffy
  putStrLn $ "format: "      ++ (show $ SF.format info)
  putStrLn $ "sample rate: " ++ (show $ SF.samplerate info)
  putStrLn $ "channels: "    ++ (show $ SF.channels info)
  putStrLn $ "frames: "      ++ (show $ SF.frames info)
  simpleWrite conn flac

connectPulseAudio :: IO Simple
connectPulseAudio = simpleNew Nothing "so-fulla" Play (Just "alsa_output.usb-Schiit_Audio_I_m_Fulla_Schiit-00-Schiit.analog-stereo") "play on the Fulla!"
          (SampleSpec (F32 LittleEndian) 44100 2) Nothing Nothing

closePulseAudio :: Simple -> IO ()
closePulseAudio conn = do
  simpleDrain conn
  simpleFree conn

withPulseAudioConn :: (Simple -> IO ()) -> IO ()
withPulseAudioConn = bracket connectPulseAudio closePulseAudio
