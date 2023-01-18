module Lib (evenSum) where
-- f :: Int -> Int -> Int
-- f x y = x*x + y*y
-- main = print(even 2)

-- version 1

-- evenSum :: [Integer] -> Integer
-- evenSum l = accumSum 0 l
-- accumSum n l = if l == []
--   then n
--   else let x = head l
--            xs = tail l
--   in if even x
--     then accumSum (n+x) xs
--     else accumSum n xs
-- main = print(evenSum [1..5])

-- version 2
-- evenSum :: Integral a => [a] -> a
-- evenSum l = accumSum 0 l
--   where accumSum n l = if l == []
--         then n
--         else let x = head l
--                  xs = tail l
--             in if even x
--               then accumSum (n+x) xs
--               else accumSum n xs
-- main = print(evenSum [1..5])

-- version 3 - pattern matching
-- evenSum l = accumSum 0 l
--   where
--     accumSum n [] = n
--     accumSum n (x:xs) = if even x
--       then accumSum (n+x) xs
--       else accumSum n xs
-- main = print(evenSum [1..5])

-- version 4 =>  η(eta)-reducing
-- f x = (some expression) x  <==>  f = some expression

-- evenSum :: Integral a => [a] -> a
-- evenSum = accumSum 0
--   where
--     accumSum n [] = n
--     accumSum n (x:xs) = if even x
--       then accumSum (n+x) xs
--       else accumSum n xs
-- main = print(evenSum [1..5])s

-- version 5 - HOF - filter
-- evenSum l = mysum 0 (filter even l)
--   where
--     mysum n [] = n
--     mysum n (x:xs) = mysum (n+x) xs
-- main = print(evenSum [1..5])

-- version 6 - HOF foldl
-- foldl f z [] = z
-- foldl f z (x:xs) = foldl f (f z x) xs

-- import Data.List
-- evenSum l = foldl' mysum 0 (filter even l)
--   where mysum acc value = acc + value
-- main = print(evenSum [1..5])

-- version 7 - using lamda
-- import Data.List
-- evenSum l = foldl' (\x y -> x + y) 0 (filter even l)
-- main = print(evenSum [1..5])

-- version 8 
-- import Data.List
-- evenSum l = foldl' (+) 0 (filter even l)
-- main = print(evenSum [1..5])

-- version 9 - eta -reduce with (.)
-- import Data.List (foldl')
-- evenSum :: Integral a => [a] -> a
-- evenSum = (foldl' (+) 0).(filter even)
-- main = print(evenSum [1..5])

-- version 10 - rename function
import Data.List (foldl')
sum' :: (Num a) => [a] -> a
sum' = foldl' (+) 0
evenSum :: Integral a => [a] -> a
evenSum = sum' . filter even
main = print(evenSum [1..5])
