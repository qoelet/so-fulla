module PlayListSpec where

import           Test.Hspec

import           PlayList

spec :: Spec
spec = do
  describe "readPlayList" $
    it "parses a YAML file" $
      readPlayList "test/Golden/playlist.yml"
        `shouldReturn` [
            Album {
                name = "Foo"
              , artist = "Bar"
              , location = "/home/foo/music"
              , songs = Just [
                 "baa-baa.flac"
                ,"baz.flac"
                ]
              }
          , Album {
                name = "Bar"
              , artist = "Qux"
              , location = "/home/bar/music"
              , songs = Just [
                 "abc.flac"
                ,"efg.flac"
                ]
              }
          ]
  describe "playListToSource" $
    it "takes a playlist and returns the filepaths" $ do
      let albums = [
            Album {
                name = "Bar"
              , artist = "Qux"
              , location = "/home/bar/music"
              , songs = Just [
                  "abc.flac"
                 ,"efg.flac"
                ]
              }
            ]
      playListToSource albums `shouldReturn` ["/home/bar/music/abc.flac", "/home/bar/music/efg.flac"]
