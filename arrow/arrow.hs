import Control.Arrow 
addA :: Arrow m => m a Int -> m a Int -> m a Int
addA f g =
  arr (\x -> (x, x)) >>>
  first f >>> arr(\(y, x) -> (x,y)) >>>
  first g >>> arr(\(y, z) -> y + z)
main :: IO ()
main = do
  print $ addA (* 2) (^ 4) 2

