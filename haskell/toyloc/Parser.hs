module Parser where

import Text.Parsec
import Text.Parsec.String (Parser)

import qualified Text.Parsec.Expr as E
import qualified Text.Parsec.Token as T

import Lexer
import Syntax

-- parses the entire given program, returns a list of expressions on success,
-- or a error statement on failure.
-- * I assume "<stdin>" means we are reading from STDIN. But what exactly is it
--   that we are reading from STDIN? I suppose this could also be a file name?
-- * I don't know what `s` means here
parseToplevel :: String -> Either ParseError [Expr]
parseToplevel s = parse (contents toplevel) "<stdin>" s
  where
  -- parse a list of semi-colon delimited expressions
  toplevel :: Parser [Expr]
  toplevel = many $ do
    def <- expr
    {- reservedOp' "\n" -}
    return def

-- this is needed to parse individual Expr, but it doesn't seem to be called by
-- name anywhere. I don't know how it is connected to everything else.
parseExpr :: String -> Either ParseError Expr
parseExpr s = parse (contents expr) "<stdin>" s


-- conents is passed a parser (e.g. toplevel, as above), removes leading
-- whitespace and the trailing EOF, if present. Then it returns whatever the
-- given parser makes of the interior content. 
contents :: Parser a -> Parser a
contents p = do
  -- `lexer` here, is defined in Lexer.hs.  What does the inclusion of this
  -- lexer do for us?  I suppose this is removing space, but it seems like
  -- something else is going on ...
  T.whiteSpace lexer
  -- next we take everything in the input
  r <- p
  -- up until the end of file
  eof
  -- return the stuff inside
  return r


-- parse an expression, handles precedence and associativity
expr :: Parser Expr
expr = E.buildExpressionParser table factor
  where
  -- all expressions that evaluate to a legal element in an expression
  factor :: Parser Expr
  factor =
        try num
    <|> try int
    <|> try str
    <|> try apply
    <|> node
  -- binary operators, listed in order of precedence
  table =
    [[binary "." Dot E.AssocRight]]
    where
    -- s     string e.g. "*"
    -- f     symbol e.g. Times
    -- assoc associativity [E.AssocLeft, E.AssocRight]
    binary s f assoc = E.Infix (reservedOp' s >> return (BinOp f)) assoc

num :: Parser Expr
num = float' >>= return . Float 

int :: Parser Expr
int = integer' >>= return . Integer

str :: Parser Expr
str = string' >>= return . String

node :: Parser Expr
node = identifier' >>= return . Node

apply :: Parser Expr
apply = do
  name <- node
  args <- many1 composon
  return $ Apply name args
  where
  composon =
        try node
    <|> try str
    -- num before int, else "." is parsed as COMPOSE
    <|> try num
    <|>     int
