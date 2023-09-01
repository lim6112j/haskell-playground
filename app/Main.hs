{-# LANGUAGE InstanceSigs#-}
module Main where

-- import Lib
-- import IOLib
class Tofu t where
  tofu :: j a -> t a j
data Frank a b = Frank {frankField::b a} deriving (Show)

instance Tofu Frank where
  tofu x = Frank x
data Barry t k p = Barry{yabba::p, papa::t k} deriving (Show)
-- check kind for understanding below code
instance Functor (Barry a b) where
  fmap :: (x -> y) -> Barry c d x -> Barry c d y
  fmap f (Barry {yabba = x, papa = y}) = Barry{ yabba = f x, papa = y }
main :: IO()
main = print $ (\x -> x * 3) <$> Barry {yabba=2, papa = Just 2}
