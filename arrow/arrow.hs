{-# LANGUAGE Arrows #-}

import Control.Arrow

addA :: Arrow m => m a Int -> m a Int -> m a Int
addA f g =
  arr (\x -> (x, x))
    >>> first f
    >>> arr (\(y, x) -> (x, y))
    >>>
    -- first g >>> arr(\(y, z) -> y + z)
    first g
    >>> arr (uncurry (+))

addA' :: Arrow m => m a Int -> m a Int -> m a Int
addA' f g = f &&& g >>> arr (uncurry (+))

addA'' :: Arrow m => m a Int -> m a Int -> m a Int
addA'' f g = proc x -> do
  y <- f -< x
  z <- g -< x
  returnA -< y + z

main :: IO ()
main = do
  print $ addA (* 2) (^ 4) 2
  print $ addA' (* 4) (^ 2) 3
  print $ addA'' (* 4) (^ 2) 3
