module Main where

import Parser
import Control.Monad.Trans
import System.Console.Haskeline

process :: String -> IO ()
process line = do
  -- parseToplevel parses one line of Kaleidoscope code
  -- it is defined in Parser.hs
  -- The return value is wrapped in an Either
  let res = parseToplevel line
  case res of
    Left err -> print err
    -- mapM_ maps within a monad for side effects, returning nothing
    Right ex -> mapM_ print ex

main :: IO ()
main = runInputT defaultSettings loop
  where
  loop = do
    -- getInputLine - haskeline function that returns Maybe, with
    -- Nothing implying a Ctrl-D, end of file
    minput <- getInputLine "toyloc> "
    case minput of
      Nothing -> outputStrLn "You must have pressed Ctrl-D, goodbye"
      -- process input - parse the input line
      -- liftIO - do it in the IO monad
      -- `>>` - jump to the next loop, discarding current value
      Just input -> (liftIO $ process input) >> loop
