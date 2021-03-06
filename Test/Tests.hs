{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Arrow
import Control.Concurrent
import Control.Concurrent.MVar          (newEmptyMVar, takeMVar)
import Control.Monad
import Data.Binary.Tagged
import JavaScript.WebSockets
import JavaScript.WebSockets.Internal
import Data.Binary
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Base64.Lazy as B64
import qualified Data.Text              as T
import qualified Data.Text.IO           as T

main :: IO ()
main = do
  print $ (B64.encode (encode (1 :: Int)))
  conn <- openConnection "your-server"
  runningSum 0 conn
  block <- newEmptyMVar
  forkIO $ receiveMessage_ conn >>= putMVar block
  closeConnection conn
  print =<< takeMVar block
  -- receiveText conn
  -- receiveText conn
  -- forkIO . forever $ echo conn
  -- forkIO . forever $ do
  --   threadDelay 2000000
  --   print . second (fmap B64.encode) =<< viewQueues conn

runningSum :: Int -> Connection -> IO ()
runningSum n conn = do
  -- putStrLn "waiting for number"
  i <- receiveData_ conn
  print (n + i)
  send conn (show (n+i))
  -- print . second (fmap B64.encode) =<< viewQueues conn
  when ((n+1) < 50) $ runningSum (n + i) conn

echo :: Connection -> IO ()
echo conn = do
  threadDelay 500000
  putStrLn "waiting for text"
  t <- receiveText_ conn
  print t
  -- print . second (fmap B64.encode) =<< viewQueues conn


-- main :: IO ()
-- main = withUrl "server-url" $ \conn -> forever $ do
--   t <- receive conn
--   T.putStrLn t


  -- putStrLn "Hello world!"
  -- c <- openConnection "ws://home.jle0.com:4270"
  -- send c (encodeTagged ("hello" :: String))
  -- forever $ do
  --   t <- receive c
  --   T.putStrLn t


