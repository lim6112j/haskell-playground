import Control.Monad.State
import Control.Applicative (Alternative (empty))
import Text.Read(readMaybe)
type Stack = [Integer]
type EvalM = StateT Stack Maybe

push :: Integer -> EvalM ()
push x = modify (x:)

pop :: EvalM Integer
pop = do
  xs <- get
  guard (not $ null xs)
  put (tail xs)
  pure (head xs)
readSafe :: (Read a, Alternative m) => String -> m a
readSafe str =
  case readMaybe str of
    Nothing -> empty
    Just n -> pure n
oneElementOnStack :: EvalM ()
oneElementOnStack = do
  l <- length <$> get
  guard (l == 1)
evalRPN :: String -> Maybe Integer
evalRPN expr = evalStateT evalRPN' []
  where 
    evalRPN' = traverse step (words expr) >> oneElementOnStack >> pop
    step "+" = processTops (+)
    step "-" = processTops (-)
    step "*" = processTops (*)
    step t = readSafe t >>= push
    processTops op = flip op <$> pop <*> pop >>= push
