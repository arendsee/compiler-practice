module Lexer (
    Expr(..) 
  , parseExp
) where

import qualified Text.Parsec as P
import Text.Parsec.Char

data Expr
  = Identifier String
  | Application Expr Expr
  | Lambda 
  | Define String Expr Expr

type Parser = Either P.ParseError

parseExp :: String -> Expr
parseExp s = P.parse expr "Exp source" s 

expr :: Parser Expr
expr = do
      try define
  <|> try lambda
  <|> try application
  <|> try identifier

identifier :: Parser Expr
identifier = fmap Identifier letters

application :: Parser Expr
application = do
  e1 <- expr
  _  <- spaces
  e2 <- expr
  return $ Application e1 e2

lambda :: Parser Expr
lambda = do
  _ <- char '\\'
  _ <- spaces
  v <- identifier
  _ <- spaces
  _ <- char '.'
  _ <- spaces
  e <- expr
  return $ Lambda v e

define :: Parser Expr
define = do
  _  <- string "let" >> spaces
  x  <- letters
  _  <- spaces >> char '=' >> spaces
  e1 <- expr
  _  <- spaces >> string "in" >> spaces
  e2 <- expr
  return $ Define x e1 e2
