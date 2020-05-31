module Types where
-- The syntax of data is mainly:

-- data TypeName =   ConstructorName  [types]
--                 | ConstructorName2 [types]
--                 | ...
--  Usually TypeName == ConstructorName

-- version 1
-- data Name = NameConstr String
-- data Color = ColorConstr String
-- showInfos :: Name -> Color -> String
-- showInfos (NameConstr name) (ColorConstr color) =
--   "Name: " ++ name ++ ", Color: " ++ color
-- name = NameConstr "Robin"
-- color = ColorConstr "red"
-- main = putStrLn $ showInfos name color

-- version 2 , TypeName == ConstructorName
-- data Name = Name String
-- data Color = Color String
-- showInfos :: Name -> Color -> String
-- showInfos (Name name) (Color color) =
--   "Name: " ++ name ++ ", Color: " ++ color
-- name = Name "lim"
-- color = Color "Red"
-- main = putStrLn $ showInfos name color

-- recursive types
-- infixr 5 :::
-- data List a = Nil | a ::: (List a)
--   deriving (Show, Read, Eq, Ord)
-- convertList [] = Nil
-- convertList (x:xs) = x ::: convertList xs

-- main = do
--   print(1:::2:::Nil)
--   print(convertList [0..1])

-- trees
-- import Data.List
-- data BinTree a = Empty
--   | Node a (BinTree a)(BinTree a)
--     deriving (Eq, Ord)
-- instance (Show a) => Show (BinTree a) where
--   show t = "< " ++ replace '\n' "\n: " (treeshow "" t)
--     where
--       treeshow pref Empty = ""
--       -- Leaf
--       treeshow pref (Node x Empty Empty) =
--                     (pshow pref x)

--       -- Right branch is empty
--       treeshow pref (Node x left Empty) =
--                     (pshow pref x) ++ "\n" ++
--                     (showSon pref "`--" "   " left)

--       -- Left branch is empty
--       treeshow pref (Node x Empty right) =
--                     (pshow pref x) ++ "\n" ++
--                     (showSon pref "`--" "   " right)

--       -- Tree with left and right children non empty
--       treeshow pref (Node x left right) =
--                     (pshow pref x) ++ "\n" ++
--                     (showSon pref "|--" "|  " left) ++ "\n" ++
--                     (showSon pref "`--" "   " right)
--       -- shows a tree using some prefixes to make it nice
--       showSon pref before next t =
--                     pref ++ before ++ treeshow (pref ++ next) t

--       -- pshow replaces "\n" by "\n"++pref
--       pshow pref x = replace '\n' ("\n"++pref) (show x)

--       -- replaces one char by another string
--       replace c new string =
--         concatMap (change c new) string
--         where
--             change c new x
--                 | x == c = new
--                 | otherwise = x:[] -- "x"
-- treeFromList :: (Ord a) => [a] -> BinTree a
-- treeFromList [] = Empty
-- treeFromList (x:xs) = Node x (treeFromList (filter (<x) xs))
--   (treeFromList (filter (>x) xs))
-- -- main = do
-- --   putStrLn "Int binary tree:"
-- --   print $ treeFromList [7,2,4,8,1,3,6,21,12,23]
-- main = do
--   putStrLn ("\nString binary tree:")
--   print $ treeFromList ["foo","bar","baz","gor","yog"]
--   putStrLn "\nChar binary trees:"
--   print (map treeFromList ["baz","zara","bar"])
--   putStrLn "\nBinary tree of Char binary trees:"
--   print (treeFromList (map treeFromList ["baz", "zara", "bar"]))
--   putStrLn "\nTree of Binary trees of Char binary trees:"
--   print $ (treeFromList . map (treeFromList . map treeFromList))
--              [ ["YO","DAWG"]
--              , ["I","HEARD"]
--              , ["I","HEARD"]
--              , ["YOU","LIKE","TREES"] ]
 
-- infinite structure
numbers :: [Integer]
numbers = 0:map (1+) numbers
take' n [] = []
take' 0 l = []
take' n (x:xs) = x:take' (n-1) numbers
main = print $ take' 10 numbers