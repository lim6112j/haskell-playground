{-# LANGUAGE NamedFieldPuns #-}
module Utils where
import AppTypes
import Control.Monad.Trans (MonadIO (liftIO))
import Control.Monad.Trans.RWS.Lazy (ask, asks, local)
import Data.Foldable.Extra (traverse_)
import System.Directory.Extra (listDirectory)
import System.FilePath ((</>))
import System.PosixCompat.Files (FileStatus)
import System.FilePath.Posix (isExtensionOf)

currentPathStatus :: MyApp l s FileStatus
currentPathStatus = do
  AppEnv {fileStatus, path} <- ask
  liftIO $ fileStatus path

traverseDirectoryWith :: MyApp le s () -> MyApp le s ()
traverseDirectoryWith app = do
  curPath <- asks path
  content <- liftIO $ listDirectory curPath
  traverse_ go content
  where
    go name = flip local app $
      \env ->
        env
          { path = path env </> name,
            depth = depth env + 1
          }
checkExtension :: AppConfig  -> FilePath -> Bool
checkExtension cfg fp =
  maybe True (`isExtensionOf` fp) (extension cfg)
