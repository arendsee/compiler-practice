module Graph
(
      Graph(..)
    , toList
    , familyMap
    , childMap
    , parentChildMap
    , parentChildMapI
) where

import qualified Data.List as DL
import qualified Control.Monad as CM
import qualified Data.Foldable as DF

data Graph a = Leaf a | Node a [Graph a] deriving(Show, Eq)

-- local utility
value' :: Graph a -> a
value' (Leaf x)   = x 
value' (Node x _) = x 

instance Functor Graph where
  fmap f (Leaf x) = Leaf (f x)
  fmap f (Node x xs) = Node (f x) (fmap (fmap f) xs)

instance Foldable Graph where
  foldr f z (Leaf a) = f a z
  foldr f z (Node a []) = f a z
  foldr f z (Node a (x:xs)) = foldr f (foldr f z x) (Node a xs)

-- Graph to list, just a list of all a
toList :: Eq a => Graph a -> [a]
toList (Leaf x) = [x]
toList (Node x xs) = DL.union [x] (xs >>= toList)

-- modify parent by comparing to children
familyMap :: (a -> [a] -> b) -> Graph a -> Graph b
familyMap f (Leaf a) = Leaf $ f a []
familyMap f (Node t ts) = Node new_val new_kids  where
  new_val = f t $ CM.liftM value' $ ts
  new_kids = map (familyMap f) ts

-- modify parents based only on children
childMap :: ([a] -> b) -> Graph a -> Graph b
childMap f (Leaf _) = Leaf (f [])
childMap f (Node _ ts) = Node new_val new_kids where
  new_val = f $ CM.liftM value' $ ts
  new_kids = map (childMap f) ts

-- replace node values with parent/child relation lists
parentChildMap :: (a -> a -> b) -> Graph a -> Graph [b]
parentChildMap f (Leaf _) = Leaf []
parentChildMap f (Node t ts) = Node new_val new_kids where
  new_val = map (f t) (CM.liftM value' $ ts)
  new_kids = map (parentChildMap f) ts
  
-- like parentChildMap, but includes child order index
parentChildMapI :: (a -> (Int, a) -> b) -> Graph a -> Graph [b]
parentChildMapI f (Leaf _) = Leaf []
parentChildMapI f (Node t ts) = Node new_val new_kids where
  children = CM.liftM value' $ ts
  new_val = map (f t) (zip [1..] children)
  new_kids = map (parentChildMapI f) ts

popChild :: Graph a -> Maybe (Graph a)
popChild (Leaf v)    = Nothing
popChild (Node n []) = Nothing
popChild (Node n ts) = Just $ Node n (init ts)

topChild :: Graph a -> Maybe (Graph a)
topChild (Leaf v)    = Nothing
topChild (Node n []) = Nothing
topChild (Node n ts) = Just $ head $ reverse ts


{- -- DF.concat :: t [a] -> [a]                                  -}
{- -- CM.liftM :: (a -> r) -> m a -> m r                         -}
{- -- g :: Graph -> [String]                                     -}
{- -- return :: a -> m a                                         -}
{- -- (>>=) :: m a -> (a -> m b) -> m b                          -}
{- showGraph :: (Graph a -> Maybe String) -> Graph a -> [String] -}
{- showGraph f t =                                               -}
{-      (DF.toList . f) t                                        -}
{-   ++ (DF.concat . g) (return t >>= popChild)                  -}
{-   ++ (DF.concat . g) (return t >>= topChild)                  -}
{-   where                                                       -}
{-     g = CM.liftM (showGraph f)                                -}
