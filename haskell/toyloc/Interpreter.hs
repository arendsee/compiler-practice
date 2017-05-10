module Interpreter where

import qualified Data.List     as DL
import qualified Data.Foldable as DF
import qualified Control.Monad as CM
import qualified Control.Monad.Except as CE

import qualified Syntax as S
import qualified EvalError as E

expr2tree :: S.Expr -> E.ThrowsError Tree
{-
     [MorlocError a], if any element in the list is a failure, return a failure
     otherwise, extract the pure list, e.g. [MorlocError a] -> [a]
     The [a] is fed as input to the Node constructor

  let
    a := Expr
    b := Tree
    l := list monad
    e := error monad

  Overall:
      (0)    l a -> e b

  Simple components:
      (1)    l b -> b
      (2)    a -> e a

  (1) is the constructor Node (builds a node from inputs). I'll ignore the
      String argument (it can just be partially applied away)
  (2) is a expr2tree itself

  Derived:
      (3)    l a -> l (e b)
      (4)    l (e b) -> e (l b)
      (5)    e (l b) -> e b

  (3) is expr2tree lifted into l
  (4) matches the general case (Data.Traversable):
        sequenceA :: (Traversable t, Applicative f) => t (f a) -> f (t a)
      It also matches the more specific function from Control.Monad:
        sequence :: Monad m => [m a] -> m [a]
  (5) is just (1) lifted into e

  Putting all this together:
       (5) . (4) . (3) :: (0)
  filling in the functions we get:
  (liftM Node) . sequence . (liftM expr2tree)
-}

-- curried nodes outside of compositions
expr2tree (S.Apply (S.Node s) es) =
  CM.liftM (Node s) $ CM.sequence $ CM.liftM expr2tree $ es

-- simple nodes, composition without application
expr2tree (S.BinOp S.Dot (S.Node s) e) =
  CM.liftM (Node s) $ CM.sequence $ [expr2tree e]

-- simple nodes, composition with application
expr2tree (S.BinOp S.Dot (S.Apply (S.Node s) es) e) =
  CM.liftM (Node s) $ CM.sequence $ CM.liftM expr2tree $ es ++ [e]

-- singletons
expr2tree (S.Node    x) = return $ Node x []
expr2tree (S.Float   x) = return $ Leaf $ Float   x
expr2tree (S.Integer x) = return $ Leaf $ Integer x
expr2tree (S.String  x) = return $ Leaf $ String  x

-- throw error on all kinds of compositions not handled above
expr2tree (S.BinOp S.Dot _ _) = CE.throwError $ E.BadComposition msg where
  msg = "Primitives cannot be on the left side of a composition"

-- throw error on all kinds of applicaitons not handled above
expr2tree (S.Apply _ _) = CE.throwError $ E.BadApplication msg where
  msg = "Primitives cannot take arguments"


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
