{-# LANGUAGE RecordWildCards #-}
module FileCounter where
import AppTypes (MyApp, AppEnv (AppEnv, depth, cfg, path), AppConfig (maxDepth))
import Control.Monad.RWS.Lazy (when)
import Utils (currentPathStatus, traverseDirectoryWith, checkExtension)
import System.PosixCompat (isDirectory)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.RWS.Lazy (ask, tell)
import System.Directory.Extra (listFiles)
fileCount :: MyApp (FilePath, Int) s ()
fileCount = do
  AppEnv {..} <- ask
  fs <- currentPathStatus
  when (isDirectory fs && depth <= maxDepth cfg) $ do
    traverseDirectoryWith fileCount
    files <- liftIO $ listFiles path
    tell [(path, length $ filter (checkExtension cfg) files)]
