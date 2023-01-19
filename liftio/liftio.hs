import Control.Monad.Trans.Class (lift) 
import Control.Monad.Trans.State

printState :: Show s => StateT s IO ()
printState = do
  s <- get -- get state
  lift $ print s -- IO () == value

-- parser with state
type Parser = StateT String [] -- StateT s m 
runParser :: Parser a -> String -> [a]
runParser p s = [x | (x, "") <- runStateT p s]

item :: Parser Char
item = do
  c:cs <- get
  put cs
  return c
  
main :: IO ()
main = do 
  evalStateT printState "hello" -- "hello" state, evalStateT returns value == IO ()
  print $ runParser item "good"
