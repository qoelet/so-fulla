{-# LANGUAGE DeriveDataTypeable, DeriveGeneric #-}

module Main where

import           Data.Typeable
import           GHC.Generics
import           System.Console.GetOpt.Generics
import           System.Environment

import           Fulla

data Options
  = Options {
    source :: FilePath
  }
  deriving (Show, GHC.Generics.Generic)

instance System.Console.GetOpt.Generics.Generic Options
instance HasDatatypeInfo Options

main :: IO ()
main = do
  options <- getArguments
  s <- readSource (source options)
  withPulseAudio (play s)
