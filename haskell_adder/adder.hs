module Main where
import System.Environment
import Text.ParserCombinators.Parsec
import Control.Monad

main :: IO ()
main = do args <- getArgs
          putStrLn (readExpr (args !! 0))

readExpr :: String -> String
readExpr input = case parse expr' "adder" input of
    Left  err -> "Syntax error: " ++ show err
    Right val -> show val

expr' :: Parser Integer
expr' = liftM (sum . map read) $ sepBy (many1 digit) (char '+')
