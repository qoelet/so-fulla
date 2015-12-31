module FullaSpec where

import           Control.Exception
import           System.IO.Temp
import           Test.Hspec

import           Fulla

spec :: Spec
spec = do
  describe "readSource" $ do
    it "returns filepath when given a source that refers to just one file" $ do
      withSystemTempDirectory "test" $ \ tmpDir -> do
        (f, _) <- openTempFile tmpDir "foo.flac"
        readSource f `shouldReturn` [f]

    it "returns [filepath] that are flac files when given a source that's a directory" $ do
      withSystemTempDirectory "test" $ \ tmpDir -> do
        (f, _) <- openTempFile tmpDir "foo.flac"
        (g, _) <- openTempFile tmpDir "bar.flac"
        readSource tmpDir `shouldReturn` [g, f]

    it "throws an exception if file doesn't exist" $ do
      withSystemTempDirectory "test" $ \ tmpDir -> do
        readSource "bar" `shouldThrow` errorCall "file does not exist!"
