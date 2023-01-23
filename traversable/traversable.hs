import Data.Traversable
import Data.Functor.Compose
deleteNegative :: (Num a, Ord a) => a -> Maybe a
deleteNegative x = if x < 0 then Nothing else Just x

main :: IO ()
main = do
  let testList = [-1, 2, 3, 4]
  print $ fmap deleteNegative testList
  print $ traverse deleteNegative testList
  print $ traverse (\x -> [0..x]) [0..2]
