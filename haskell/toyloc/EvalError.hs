module EvalError where

import Control.Monad.Except
import Text.Parsec

data MorlocError
  = BadApplication String
  | BadComposition String
  | SyntaxError    ParseError
  | Default

instance Show MorlocError where show = morlocShow

morlocShow :: MorlocError -> String
morlocShow (BadApplication msg) = "BadApplication: " ++ msg 
morlocShow (BadComposition msg) = "BadComposition: " ++ msg
morlocShow (SyntaxError    err) = "Syntax error: "   ++ show err
morlocShow (Default           ) = "Default error"

type ThrowsError = Either MorlocError

extractValue :: ThrowsError a -> a
-- Left not defined, so that we die immediately on an error
extractValue (Right val) = val
