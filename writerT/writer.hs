import Control.Monad.Trans.Writer
import Control.Monad.Writer (MonadTrans)
import Control.Monad.State (MonadTrans(lift))
type EvalM = WriterT String IO
addM :: EvalM Int -> String -> Int -> EvalM Int
addM w s a = do
  (n, w) <- lift $ runWriterT w
  tell $ w ++ ", " ++ s
  return (n + a)

main :: IO ()
main = do
  let w = writer (0, "0")
  a@(a1, _) <- runWriterT $ addM w "add 10" 10
  (a2, l) <- runWriterT $ addM (writer a) "add 100" 100
  putStrLn $ "log : " ++ l
  print $ "result : " ++ show a2

