module Parser where

import Text.Parsec
import Text.Parsec.String (Parser)

import qualified Text.Parsec.Expr as Ex
import qualified Text.Parsec.Token as Tok

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
    def <- defn
    reservedOp ";"
    return def
    where
    -- don't knowo why they call this a `defn`, but it describes any of the
    -- complete high-level statements, an extern, function or expr.
    defn :: Parser Expr
    defn =
          try extern
      <|> try function
      <|> expr

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
  Tok.whiteSpace lexer
  -- next we take everything in the input
  r <- p
  -- up until the end of file
  eof
  -- return the stuff inside
  return r


-- parse an expression, handles precedence and associativity
expr :: Parser Expr
expr = Ex.buildExpressionParser table factor
  where
  -- all expressions that evaluate to a legal element in an expression
  factor :: Parser Expr
  factor =
        try floating
    <|> try int
    <|> try extern
    <|> try function
    <|> try call
    <|> variable
    <|> parens expr
  -- binary operators, listed in order of precedence
  table =
    [
        [ binary "*" Times Ex.AssocLeft,
          binary "/" Divide Ex.AssocLeft]
      , [ binary "+" Plus Ex.AssocLeft,
          binary "-" Minus Ex.AssocLeft]
    ]
    where
    -- s     string e.g. "*"
    -- f     symbol e.g. Times
    -- assoc associativity [Ex.AssocLeft, Ex.AssocRight]
    binary s f assoc = Ex.Infix (reservedOp s >> return (BinOp f)) assoc

extern :: Parser Expr
extern = do
  -- Make a function call
  -- extern <identifier> ( [<variable>] )
  reserved "extern"
  name <- identifier
  args <- parens $ many variable
  return $ Extern name args

function :: Parser Expr
function = do
  -- def <identifier> ( [<variable>] ) <expr>
  reserved "def"
  name <- identifier
  args <- parens $ many variable
  body <- expr
  return $ Function name args body

floating :: Parser Expr
floating = float >>= return . Float 
{- floating = do           -}
{-   n <- float            -}
{-   return $ Float n      -}

int :: Parser Expr
int = integer >>= return . Float . fromInteger
{- int = do                                                                  -}
{-   -- get a value from the integer parser                                  -}
{-   n <- integer                                                            -}
{-   -- since Kaleidoscope only has doubles as numbers, convert int to float -}
{-   return $ Float (fromInteger n)                                          -}

variable :: Parser Expr
variable = identifier >>= return . Var
{- variable = do       -}
{-   var <- identifier -}
{-   return $ Var var  -}

call :: Parser Expr
call = do
  -- <identifier> ( [<expr>] [, <expre>] )
  name <- identifier
  args <- parens $ commaSep expr
  return $ Call name args
