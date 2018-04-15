module Main where

import Server
import Lib
import System.Environment

main :: IO ()
main = do
  maybeport <- lookupEnv "PORT"
  let port = case maybeport of
               Just p  -> read p
               Nothing -> 3000
  server port
  
