module Control where

import           Control.Concurrent

newtype KeyListen = Key (MVar String)

initKey :: IO KeyListen
initKey = do
  kL <- newMVar ""
  return $ Key kL

readKeyUnchanged :: KeyListen -> IO String
readKeyUnchanged (Key s) = readMVar s

readKey :: KeyListen -> IO String
readKey (Key s) = do
  k <- readMVar s
  modifyMVar_ s resetKey
  return k

writeKey :: Char -> KeyListen -> IO ()
writeKey x (Key s) = do
  let x' = x : ""
  modifyMVar_ s (\ _ -> return x')

resetKey :: String -> IO String
resetKey _ = return ""

-- controls

nextSong :: KeyListen -> IO Bool
nextSong k = do
  c <- readKey k
  return $ c == " "

quit :: KeyListen -> IO Bool
quit k = (== "q") <$> readKeyUnchanged k

pollUser :: KeyListen -> IO ()
pollUser key@(Key s) = do
  k <- readMVar s
  case k of
    "" -> do
      input <- getChar
      writeKey input key
      pollUser key
    _ -> do
      threadDelay 100000
      pollUser key
