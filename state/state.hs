import Control.Monad.State
tick :: State Int Int
tick = do
  n <- get
  put (n + 1)
  return n
plusOne :: Int -> Int
plusOne n = execState tick n
main :: IO ()
main = do
  print $ plusOne 2
