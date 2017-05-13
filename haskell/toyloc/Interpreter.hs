module Interpreter where

import qualified Data.List as DL
import qualified Data.Foldable as DF
import qualified Control.Monad as CM
import qualified Control.Monad.Except as CE

import qualified Syntax as S
import qualified EvalError as E
import Graph
import NodeAttribute

-- see Note
expr2tree :: S.Expr -> E.ThrowsError (Graph NodeAttr)
-- curried nodes outside of compositions
expr2tree (S.Apply (S.Node s) es) =
  CM.liftM (Node $ nodeAttrS s) $ CM.sequence $ CM.liftM expr2tree $ es where

-- simple nodes, composition without application
expr2tree (S.BinOp S.Dot (S.Node s) e) =
  CM.liftM (Node $ nodeAttrS s) $ CM.sequence $ [expr2tree e]

-- simple nodes, composition with application
expr2tree (S.BinOp S.Dot (S.Apply (S.Node s) es) e) =
  CM.liftM (Node $ nodeAttrS s) $ CM.sequence $ CM.liftM expr2tree $ es ++ [e]

-- singletons
expr2tree (S.Node    x) = return $ Node (nodeAttrS x) []
expr2tree (S.Float   x) = return $ Leaf $ Primitive $ Float   x
expr2tree (S.Integer x) = return $ Leaf $ Primitive $ Integer x
expr2tree (S.String  x) = return $ Leaf $ Primitive $ String  x

-- throw error on all kinds of compositions not handled above
expr2tree (S.BinOp S.Dot _ _) = CE.throwError $ E.BadComposition msg where
  msg = "Primitives cannot be on the left side of a composition"

-- throw error on all kinds of applicaitons not handled above
expr2tree (S.Apply _ _) = CE.throwError $ E.BadApplication msg where
  msg = "Primitives cannot take arguments"

-- connect the parent to the top child 
-- this function will be used by Graph.familyMap
topLIL :: NodeAttr -> (Int, NodeAttr) -> String
topLIL (Primitive x) _ = ""
topLIL p (i, c) = join [pval', pid', pos', typ', nam']
    where
    pval' = case node_value p of
      Just x -> x
      Nothing -> "UNDEFINED" -- TODO: this should throw an error
    pid' = case node_id p of
      Just i -> show i
      Nothing -> "UNDEFINED" -- TODO: this should throw an error
    pos' = show i
    typ' = typeStr c
    nam' = valStr c
    join :: [String] -> String
    join = foldr (++) "" . DL.intersperse "\t"

toLIL :: Graph NodeAttr -> String 
toLIL g = unlines $ foldr1 (++) $ parentChildMapI topLIL g

{- Note

     [MorlocError a], if any element in the list is a failure, return a failure
     otherwise, extract the pure list, e.g. [MorlocError a] -> [a]
     The [a] is fed as input to the Node constructor

  let
    a := Expr
    b := Graph
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
