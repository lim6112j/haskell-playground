import Control.Monad.Reader
import Data.Map (Map)
import qualified Data.Map as Map

type Bindings = Map String Int
isCountCorrect :: Bindings -> Bool
isCountCorrect  = runReader calcIsCountCorrect

calcIsCountCorrect :: Reader Bindings Bool
calcIsCountCorrect = do
  count <- asks (lookupVar "count")
  bindings <- ask
  return (count == Map.size bindings)

lookupVar :: String -> Bindings -> Int
lookupVar name bindings = maybe 0 id (Map.lookup name bindings)

sampleBindings :: Bindings
sampleBindings = Map.fromList [("count", 3), ("1", 1), ("b", 2)]

main :: IO ()
main = do
  putStr $ "Count is correct for bindings " ++ (show sampleBindings) ++ ": "
  putStrLn $ show (isCountCorrect sampleBindings)
