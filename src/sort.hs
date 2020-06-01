quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
  let smallerOrEqual = [a | a <- xs, a <= x]
      bigger = [a | a <- xs, a > x]
  in quicksort smallerOrEqual ++ [x] ++ quicksort bigger

main = print(quicksort "the quick brown fox jumps over the lazy dog")