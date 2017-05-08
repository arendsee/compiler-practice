module Lexer where

import Text.Parsec.String (Parser)
import Text.Parsec.Language (emptyDef)
import qualified Text.Parsec.Token as Tok

lexer :: Tok.TokenParser ()
lexer = Tok.makeTokenParser style
  where
    -- the reserved operators
    ops = ["+","*","-",";"]
    -- the reserved keywords
    names = ["def","extern"]
    -- set the language
    style = emptyDef {
              Tok.commentLine = "#"
            , Tok.reservedOpNames = ops
            , Tok.reservedNames = names
            }

-- Below we build all the base combinators

-- The following all find simple tokens: ints, floats, identifiers, reserved
-- keywords, operators

integer :: Parser Integer
integer = Tok.integer lexer

float :: Parser Double
float = Tok.float lexer

identifier :: Parser String
identifier = Tok.identifier lexer

reserved :: String -> Parser ()
reserved = Tok.reserved lexer

reservedOp :: String -> Parser ()
reservedOp = Tok.reservedOp lexer

-- extracts an expression from within parentheses
parens :: Parser a -> Parser a
parens = Tok.parens lexer

-- separates a comma separated list into a list of values
commaSep :: Parser a -> Parser [a]
commaSep = Tok.commaSep lexer

-- separates a semicolon separated list into values
semiSep :: Parser a -> Parser [a]
semiSep = Tok.semiSep lexer
