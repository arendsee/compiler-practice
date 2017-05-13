module NodeAttribute
(
    NodeAttr(..)
  , Value(..)
  , typeStr
  , valStr
  , nodeAttrS
) where

type ID = Int

data Value
  = Integer  Integer
  | Float    Double
  | String   String
  deriving(Show,Eq,Ord)

data NodeAttr
  = Primitive Value 
  | Function {
        node_id    :: Maybe ID
      , node_value :: Maybe String
      , node_type  :: Maybe String
    }
  deriving(Show,Eq,Ord)

nodeAttrS :: String -> NodeAttr
nodeAttrS s = Function {
    node_id    = Nothing
  , node_value = Just s
  , node_type  = Nothing
}

typeStr :: NodeAttr -> String
typeStr (Primitive (Integer x)) = "Integer"
typeStr (Primitive (Float   x)) = "Float"
typeStr (Primitive (String  x)) = "String"
typeStr func =
  case node_type func of
    (Just x) -> x
    Nothing  -> ""

valStr :: NodeAttr -> String
valStr (Primitive (Integer x)) = show x
valStr (Primitive (Float   x)) = show x
valStr (Primitive (String  x)) = "\"" ++ x ++ "\""
valStr func =
  case node_value func of
    (Just x) -> x
    Nothing  -> ""


{- main :: IO ()                                      -}
{- main = do                                          -}
{-   let x = Function (Just 1) (Just "foo") (Nothing) -}
{-   print x                                          -}
{-   print $ valStr x                                 -}
{-   print $ typeStr x                                -}
{-   let a = Primitive (Float 1.2321)                 -}
{-   print a                                          -}
{-   print $ valStr a                                 -}
{-   print $ typeStr a                                -}
{-   let b = Primitive (String "asfd")                -}
{-   print b                                          -}
{-   print $ valStr b                                 -}
{-   print $ typeStr b                                -}
