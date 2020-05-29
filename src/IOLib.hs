module IOLib where
import Data.Maybe
toList :: String -> [Integer]
toList input = read("[" ++ input ++ "]")
maybeRead :: Read a => String -> Maybe a
maybeRead s = case reads s of
  [(x, "")] -> Just x
  _ -> Nothing
getListFromString :: String -> Maybe [Integer]
getListFromString str = maybeRead $ "[" ++ str ++ "]"
main :: IO()
main = do
  putStrLn "Enter a list of numbers (separated by coma):"
  input <- getLine
  let maybeList = getListFromString input in
    case maybeList of
      Just l -> print (sum l)
      Nothing -> error "Bad format, good bye"