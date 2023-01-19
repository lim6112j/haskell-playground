import System.Random
import Control.Monad.RWS
main :: IO ()
main = do 
  answer <- getStdRandom (randomR (1, 10))
  let maxTries = 5
  putStrLn "I'm thinking of a number between 1 and 10, can you guess it?"
  putStrLn $ "You've got " ++ show maxTries ++ " tries!"
  (guesses, log) <- execRWST (guessSession answer) maxTries 0
  putStrLn $ "Finished in " ++ show guesses ++ " tries."
  putStrLn $ "Guesses: " ++ show log

guessSession :: Int -> RWST Int [Int] Int IO ()
guessSession answer = do
  maxTries <- ask -- get the maxTries from Reader env 
  gs <- lift getLine -- get guess from user
  let g = read gs -- convert to number
  tell $ [g] -- log guess to writer
  modify (+1) -- increment number of guesses in state
  tries <- get -- get current number of guess from state
  case (compare g answer, compare tries maxTries) of
    (EQ, _) -> do lift $ putStrLn "Got it!"
    (LT, EQ) -> do lift $ putStrLn "Too low"
                   lift $ putStrLn "Game Over"
    (GT, EQ) -> do lift $ putStrLn "Too high"
                   lift $ putStrLn "Game Over"
    (LT, _) -> do lift $ putStrLn "Too low"
                  guessSession answer
    (GT, _) -> do lift $ putStrLn "Too high"
                  guessSession answer
