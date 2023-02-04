{-# LANGUAGE OverloadedStrings, GeneralisedNewtypeDeriving #-}
import Prelude hiding(foldl)
foldl :: (a->b->a) -> a -> [b] -> a
foldl f a bs =
  foldr (\b g x -> g(f x b)) id bs a

newtype Update a = Update {evalUpdate :: a -> a} deriving (Monoid, Semigroup)
foldlMonoid :: Monoid a => (a->b->a) -> a -> [b] -> a
foldlMonoid f a bs =
  flip evalUpdate a $
  mconcat $
  map (Update. flip f) bs
main :: IO ()
main = do 
  putStrLn "hello"
  let value = foldl (+) 0 [1..100]
  print value
  let value2 = foldlMonoid mappend "" ["1", "2", "3"]  
  print value2
