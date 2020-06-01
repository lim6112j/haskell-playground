tell :: (Show a) => [a] -> String
tell [] = "The list is empty"
tell (x:[]) = "The list has one element: " ++ show x
tell (x:y:[]) = "The list has two elements " ++ show x ++ " and " ++ show y
tell (x:y:_) = "This list is long. the First two elements are: " ++ show x ++ " and " ++ show y

-- main = print(tell [1])
-- main = do
--   let xs = [(1,3), (4,3), (2,4), (5,3), (5,6), (3,1)] 
--     -- in print([a+b | (a,b) <- xs])
--     in print(boomBang [4..13])

boomBang xs = [if x<10 then "BOOM" else "BANG" | x <- xs, odd x]

-- main = do
--   let xs = [x | x<-[10..20], x /= 13, x /= 15, x /= 19] in
--     print(xs)

removeNonUppercase st = [c | c<-st, c `elem` ['A'..'Z']]
-- main = do
--   print(removeNonUppercase "IdontLIKEFROGS")
