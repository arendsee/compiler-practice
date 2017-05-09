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
  join = foldr (++) "" . intersperse "\t"

-- But this overuse of case is a bad smell, there is some monad magic that can
-- be applied here ...
showTree :: Tree -> (Tree -> Maybe String) -> [String]
showTree (Leaf _) _ = []
showTree (Node _ []) _ = []
showTree t f =
  case f t of
    Nothing  -> []
    (Just s) -> [s]
  ++ case popChild t of
    Nothing   -> []
    (Just tt) -> showTree tt f
  ++ case topChild t of
    Nothing   -> []
    (Just tt) -> showTree tt f

main :: IO ()
main = do
  let t1 = Node "foo" [Node "bar" [Leaf $ Integer 1, Leaf $ Float 1.2], Leaf (String "yolo")]  
  putStr $ unlines $ sort $ showTree t1 topLil
