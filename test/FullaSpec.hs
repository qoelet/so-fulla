module FullaSpec where

import           System.FilePath.Posix ((</>))
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

  describe "isFlac" $ do
    it "returns true if given file is FLAC" $ do
      pending
