import Data.Char
import System.Environment
import Text.ParserCombinators.ReadP

main :: IO ()
main = do
  args <- getArgs
  mapM_ putStrLn args
  let p = string "my name is " *> munch1 isAlpha <* eof
  let x = readP_to_S p $ head args
  print x
