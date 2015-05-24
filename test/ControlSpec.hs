module ControlSpec where

import           Test.Hspec

import           Control

spec :: Spec
spec = do
  describe "initKey" $ do
    it "returns an MVar set to an empty char" $ do
      kL <- initKey
      readKey kL `shouldReturn` ""

  describe "nextSong" $ do
    it "returns true when input is n" $ do
      kL <- initKey
      writeKey 'n' kL
      nextSong kL `shouldReturn` True
