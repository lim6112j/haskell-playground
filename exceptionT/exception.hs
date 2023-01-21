{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-methods #-}
import Data.Text 
import qualified Data.Text as T
import Data.Text.Read (decimal)
import Data.Char
import Data.Foldable (traverse_)
import Control.Applicative (Alternative (empty))
import Text.Read(readMaybe)
import Control.Monad.State
import Control.Monad.Trans.Except
import Control.Monad.Trans.Reader
import Control.Monad.Error.Class
import TextShow
import Prelude hiding (null, empty, words)
rpns :: [Text]
rpns = ["answer", "12 13 + 1", "2 +", "x y +", "1x +", "1 22 1 22 0 2 + + * * *", "10 1 2 + 2 2 1 2 * + * * * 1 x 2 + + +"]
type Stack = [Integer]
type EnvVars = [(Text, Integer)]
data EvalError where
  NotEnoughElements :: EvalError
  ExtraElements :: EvalError
  NotANumber :: Text -> EvalError
  UnknownVar :: Text -> EvalError deriving (Semigroup, Monoid)
instance TextShow EvalError where
  showb NotEnoughElements = "Not Enough Elements in the expression"
  showb ExtraElements = "There are extra elements in the expression"
  showb (NotANumber t) = "Expression Component '" <>
                          fromText t <> "' is not a number"
  showb (UnknownVar t) = "Expression Component '" <>
                          fromText t <> "' is Unknown"
type EvalM = ReaderT EnvVars (ExceptT EvalError (State Stack)) 
push :: Integer -> EvalM ()
push n = modify (n:)

pop :: EvalM Integer
pop = get >>= pop'
  where pop' :: Stack -> EvalM Integer
        pop' [] = throwError NotEnoughElements
        pop' (x:xs) = put xs >> pure x
oneElementOnStack :: EvalM ()
oneElementOnStack = do
  len <- gets Prelude.length
  when (len /= 1) $ throwError ExtraElements
readVar :: Text -> EvalM Integer
readVar name = do
  var <- asks (lookup name)
  case var of
    Just n -> pure n
    Nothing -> throwError $ UnknownVar name

readNumber :: Text -> EvalM Integer
readNumber txt =
  case decimal txt of
    Right (n, rest) | T.null rest -> pure n
    _ -> throwError $ NotANumber txt
readSafe :: Text -> EvalM Integer
readSafe t
  | isId t = readVar t
  | otherwise = readNumber t
  where
  isId txt = maybe False (isLetter . fst) (T.uncons txt)
  
evalRPNOnce :: Text -> EvalM Integer
evalRPNOnce str =
  clearStack >> traverse_ step (words str) >> oneElementOnStack >> pop
  where
  clearStack = put []
  step "+" = processTops (+)
  step "*" = processTops (*)
  step "-" = processTops (-)
  step t = readSafe t >>= push
  processTops op = flip op <$> pop <*> pop >>= push
reportEvalResults :: Either EvalError Integer -> Text
reportEvalResults (Left e) = "Error: " <> showt e
reportEvalResults (Right b) = showt b
evalRPNOnceRun :: Text -> EnvVars -> Text
evalRPNOnceRun str env = reportEvalResults $ evalState (runExceptT (runReaderT (evalRPNOnce str) env)) []
  where
    buildOk res= "=" <> showb res
rpn :: Text
rpn = "1 2 + 4 2 + *"
rpnerr = "1 2 + 4 2 + * 1"
rpnerr2 = "x 2 +"
rpnerr3 = "2 +"
rpnerr4 = "answer 1 +"
rpnerr5 = "1x +"
env :: EnvVars
env = [("answer", 11), ("x", 1)]
main :: IO ()
main = do 
  print $ mapM evalRPNOnceRun rpns env

