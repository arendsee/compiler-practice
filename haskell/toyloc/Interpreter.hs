module Interpreter where

import qualified Data.List     as DL
import qualified Data.Foldable as DF
import qualified Control.Monad as CM

import qualified Syntax as S

expr2tree :: S.Expr -> Tree
-- simple nodes, curried or not
expr2tree (S.BinOp S.Dot          (S.Node s)     e) = Node s [expr2tree e]
expr2tree (S.BinOp S.Dot (S.Apply (S.Node s) es) e) = Node s (map expr2tree es ++ [expr2tree e])
-- -- expr2tree (S.BinOp S.Dot _ _) -- ERROR!!!

-- curried nodes outside of compositions
expr2tree (S.Apply (S.Node s) es) = Node s (map expr2tree es)
-- -- expr2tree (S.Apply _ es) -- ERROR!!!

-- singletons
expr2tree (S.Node    x) = Node x []
expr2tree (S.Float   x) = Leaf $ Float   x
expr2tree (S.Integer x) = Leaf $ Integer x
expr2tree (S.String  x) = Leaf $ String  x

data Value
  = Integer Integer
  | Float   Double
  | String  String
  deriving(Show)

data Tree 
  = Leaf Value
  | Node String [Tree]
  deriving(Show)

popChild :: Tree -> Maybe Tree
popChild (Leaf v)    = Nothing
popChild (Node n []) = Nothing
popChild (Node n ts) = Just $ Node n (init ts)

typeStr :: Tree -> String
typeStr (Leaf (Integer x)) = "Integer"
typeStr (Leaf (Float   x)) = "Float"
typeStr (Leaf (String  x)) = "String"
typeStr (Node _ _)         = "Node"

treeVal :: Tree -> String
treeVal (Leaf (Integer x)) = show x
treeVal (Leaf (Float   x)) = show x
treeVal (Leaf (String  x)) = show x
treeVal (Node x _) = x

topChild :: Tree -> Maybe Tree
topChild (Leaf v)    = Nothing
topChild (Node n []) = Nothing
topChild (Node n ts) = Just $ head $ reverse ts

-- connect the parent to the top child 
topLil :: Tree -> Maybe String
topLil (Leaf _) = Nothing
topLil (Node n []) = Nothing
topLil (Node n ts) = Just $ (join [n, pos, typ, nam])
  where
  top = head $ reverse ts
  pos = show $ length ts
  typ = typeStr top
  nam = treeVal top
  join :: [String] -> String
  join = foldr (++) "" . DL.intersperse "\t"

-- DF.concat :: t [a] -> [a]
-- CM.liftM :: (a -> r) -> m a -> m r
-- g :: Tree -> [String]
-- return :: a -> m a
-- (>>=) :: m a -> (a -> m b) -> m b
showTree :: (Tree -> Maybe String) -> Tree -> [String]
showTree f t =
     (DF.toList . f) t
  ++ (DF.concat . g) (return t >>= popChild)
  ++ (DF.concat . g) (return t >>= topChild)
  where
    g = CM.liftM (showTree f)
