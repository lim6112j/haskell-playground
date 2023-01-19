import Control.Monad.Trans.Class (lift) 
import Control.Monad.Trans.State

printState :: Show s => StateT s IO ()
printState = do
  s <- get -- get state
  lift $ print s -- IO () == value
main :: IO ()
main = evalStateT printState "hello" -- "hello" state, evalStateT returns value == IO ()
