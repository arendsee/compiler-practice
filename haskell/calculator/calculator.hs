module Main where
import System.Environment
import Text.ParserCombinators.Parsec
import Control.Monad

main :: IO ()
main = getArgs >>= putStrLn . show . eval . readExpr . (!! 0)

readExpr :: String -> Expression 
readExpr input = case parse readExpr "calculator" input of
    Left  err -> String $ "Syntax error: " ++ show err
    Right val -> val 

data Expression = Expression Operator [Value]

data Token =
    Value Integer |
    Operator Char |
    Statement [Token]

tokenize :: Parser [Token]
tokenize = many (parseValue <|> parseOperator <|> parseStatement)
