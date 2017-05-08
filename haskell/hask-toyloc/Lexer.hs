module Lexer where

import Text.Parsec
import Text.Parsec.String (Parser)
import Text.Parsec.Language (emptyDef)
import qualified Text.Parsec.Token as T
import qualified Text.ParserCombinators.Parsec as C

lexer :: T.TokenParser ()
lexer = T.makeTokenParser style
  where
    -- the reserved operators
    ops = [".",";"]
    -- the reserved keywords
    names = []
    -- set the language
    style = emptyDef {
              T.commentLine = "#"
            , T.reservedOpNames = ops
            , T.reservedNames = names
            -- TODO make strings be double quote only
            }

-- Below we build all the base combinators

integer' :: Parser Integer
integer' = T.integer lexer

float' :: Parser Double
float' = T.float lexer

string' :: Parser String
string' = do
  C.char '"'
  s <- C.many ((C.char '\\' >> C.char '"' ) <|> C.noneOf "\"")
  C.char '"'
  return s

identifier' :: Parser String
identifier' = T.identifier lexer

reserved' :: String -> Parser ()
reserved' = T.reserved lexer

reservedOp' :: String -> Parser ()
reservedOp' = T.reservedOp lexer
