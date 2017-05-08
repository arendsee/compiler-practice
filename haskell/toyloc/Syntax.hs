module Syntax where

type Node = String

-- why do they have to derive Eq and Ord?
data Expr
  = Float   Double
  | Integer Integer
  | String  String
  | Node    Node
  | BinOp   Op Expr Expr
  | Apply   Expr [Expr]
  deriving (Eq, Ord, Show)

data Op
  = Compose  -- "."
  deriving (Eq, Ord, Show)
