module PlayListSpec where

import           Test.Hspec

import           PlayList

spec :: Spec
spec = do
  describe "readPlayList" $ do
    it "parses a YAML file" $ do
      readPlayList "/home/revtintin/labs/so-fulla/playlist.yaml"
        `shouldReturn`
          Album {name = "Foo", artist = "Bar", location = "/home/foo/music", songs = Just ["baa-baa.flac","baz.flac"]} :
          Album {name = "Bar", artist = "Qux", location = "/home/bar/music", songs = Just ["abc.flac","efg.flac"]} :
          []

  describe "playListToSource" $ do
    it "takes a playlist and returns the filepaths" $ do
      let albums = [Album {name = "Bar", artist = "Qux", location = "/home/bar/music", songs = Just ["abc.flac","efg.flac"]}]
      playListToSource albums `shouldReturn` ["/home/bar/music/abc.flac", "/home/bar/music/efg.flac"]
