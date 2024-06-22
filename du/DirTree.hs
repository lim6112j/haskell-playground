{-# LANGUAGE RecordWildCards #-}
module DirTree where
import AppTypes (MyApp, AppEnv (AppEnv, depth, cfg, path), AppConfig (maxDepth))
import Utils (currentPathStatus, traverseDirectoryWith)
import System.PosixCompat (isDirectory)
import Control.Monad.RWS.Lazy (when)
import System.FilePath.Posix (takeBaseName)
import Control.Monad.Trans.RWS.Lazy (ask, tell)
import TextShow (Builder, fromString)
dirTree :: MyApp (FilePath, Int) s ()
dirTree = do
  AppEnv {..} <- ask
  fs <- currentPathStatus
  when (isDirectory fs && depth <= maxDepth cfg) $ do
    tell [(takeBaseName path, depth)]
    traverseDirectoryWith dirTree
treeEntryBuilder :: (FilePath, Int) -> Builder
treeEntryBuilder (fp, n) = fromString indent <> fromString fp
  where
    indent = replicate (2*n) ' '
