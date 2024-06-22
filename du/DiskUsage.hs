{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns #-}
module DiskUsage where
import AppTypes (MyApp, AppEnv (AppEnv, depth, cfg, path), AppConfig (maxDepth))
import Control.Monad.RWS.Lazy (when)
import Utils (currentPathStatus, traverseDirectoryWith, checkExtension)
import System.PosixCompat (isDirectory)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.RWS.Lazy (ask, tell, get, modify)
import System.Directory.Extra (listFiles)
import System.PosixCompat.Types (FileOffset)
import System.PosixCompat.Files
import Control.Monad.RWS (liftM2)
data DUEntryAction =
  TraverseDir {dirpath :: FilePath, requireReporting :: Bool}
  | RecordFileSize {fsize :: FileOffset}
  | None
diskUsage = liftM2 decide ask currentPathStatus >>= processEntry
  where
    decide AppEnv {..} fs
      | isDirectory fs =
          TraverseDir path (depth <= maxDepth cfg)
      | isRegularFile fs && checkExtension cfg path =
          RecordFileSize (fileSize fs)
      | otherwise = None
    processEntry TraverseDir {..} = do
      usageOnEntry <- get
      traverseDirectoryWith diskUsage
      when requireReporting $ do
        usageOnExit <- get
        tell [(dirpath, usageOnExit - usageOnEntry)]
    processEntry RecordFileSize {fsize} = modify (+ fsize)
    processEntry None = pure ()
