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

-- example 2

calculateContentLen :: Reader String Int
calculateContentLen = do
  content <- ask
  return (length content)

calculateModifiedContentLen :: Reader String Int
calculateModifiedContentLen = local ("prefix" ++) calculateContentLen

printReaderContent :: ReaderT String IO ()
printReaderContent = do
  content <- ask
  liftIO $ putStrLn ("The Reader Content: " ++ content)

main :: IO ()
main = do
  putStr $ "Count is correct for bindings " ++ (show sampleBindings) ++ ": "
  putStrLn $ show (isCountCorrect sampleBindings)
  let s = "12345"
  let modifiedLen = runReader calculateModifiedContentLen s
  let len = runReader calculateContentLen s
  putStrLn $ "Modified 's' length: " ++ (show modifiedLen)
  putStrLn $ "Original 's' length: " ++ (show len)
  runReaderT printReaderContent "Some Content"
