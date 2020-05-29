f :: Int -> Int -> Int
f x y = x*x + y*y
main = print(even 2)
-- version 1
evenSum :: [Integer] -> Integer

evenSum l = accumSum 0 l

accumSum n l = if l == []
                  then n
                  else let x = head l
                           xs = tail l
                       in if even x
                              then accumSum (n+x) xs
                              else accumSum n xs

evenSum [1..5]