{- module Interpreter where -}

-- TODO
-- fix the TODO's below
-- link the tree here to the expressions in syntax
-- incorporate this printing into Main
-- write a DOT function that can be used in place of `topLil`

import Data.List

data Value
  = Integer Integer
  | Float   Float
  | String  String
  deriving(Show)

data Tree 
  = Node String [Tree]
  | Leaf Value
  deriving(Show)

-- TODO change to `Tree -> Maybe Tree`
popChild :: Tree -> Tree
popChild (Leaf v)    = Leaf v
popChild (Node n []) = Node n []
popChild (Node n ts) = Node n (init ts)

typeStr :: Tree -> String
typeStr (Leaf (Integer x)) = "Integer"
typeStr (Leaf (Float   x)) = "Float"
typeStr (Leaf (String  x)) = "String"
typeStr (Node _ _)         = "Node"

-- TODO use Maybe
treeVal :: Tree -> String
treeVal (Leaf (Integer x)) = show x
treeVal (Leaf (Float   x)) = show x
treeVal (Leaf (String  x)) = show x
treeVal (Node x _) = x

-- TODO change to `Tree -> Maybe Tree`
topChild :: Tree -> Tree
topChild (Leaf v)    = Leaf v
topChild (Node n []) = Node n []
topChild (Node n ts) = head $ reverse ts

-- connect the parent to the top child 
-- TODO change to `Tree -> Maybe String`
topLil :: Tree -> String
topLil (Leaf _) = ""
topLil (Node n []) = ""
topLil (Node n ts) = join [n, pos, typ, nam]
  where
  top = head $ reverse ts
  pos = show $ length ts
  typ = typeStr top
  nam = treeVal top
  join :: [String] -> String
  join = foldr (++) "" . intersperse "\t"

-- TODO - monadize this bitch 
showTree :: Tree -> (Tree -> String) -> [String]
showTree (Leaf _) _ = []
showTree (Node _ []) _ = []
showTree t f = [f t] ++ showTree (popChild t) f ++ showTree (topChild t) f


main :: IO ()
main = do
  let t1 = Node "foo" [Node "bar" [Leaf $ Integer 1, Leaf $ Float 1.2], Leaf (String "yolo")]  
  putStr $ unlines $ sort $ showTree t1 topLil
