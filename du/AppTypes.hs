{-# LANGUAGE RecordWildCards #-}
module AppTypes where
import Control.Monad.RWS.Lazy (RWST, evalRWST)
import System.PosixCompat.Files (FileStatus)

data AppConfig = AppConfig
  { basePath :: FilePath,
    maxDepth :: Int,
    extension :: Maybe String,
    followSymlinks :: Bool
  }

data AppEnv = AppEnv
  { cfg :: AppConfig,
    path :: FilePath,
    depth :: Int,
    fileStatus :: FilePath -> IO FileStatus
  }

initialEnv :: AppConfig -> AppEnv
initialEnv config@AppConfig {..} =
  AppEnv
    { cfg = config,
      path = basePath,
      depth = 0,
      fileStatus =
        if followSymlinks
          then getFileStatus
          else getSymbolicLinkStatus
    }

getSymbolicLinkStatus :: FilePath
getSymbolicLinkStatus = _

getFileStatus :: FilePath
getFileStatus = _
type MyApp logEntry state = RWST AppEnv [logEntry] state IO
runMyApp :: MyApp logEntry state a -> AppConfig -> state -> IO (a, [logEntry])
runMyApp app config st = evalRWST app (initialEnv config) st
