{-# LANGUAGE OverloadedStrings #-}
module Main where
import AppTypes (AppConfig (..), runMyApp)
import System.PosixCompat.Types (FileOffset)
import DirTree (dirTree, treeEntryBuilder)
import FileCounter (fileCount)
import DiskUsage (diskUsage)
import TextShow
import qualified Data.Text.IO as TIO


work :: AppConfig -> IO ()
work config = do
  (_, dirs) <- runMyApp dirTree config ()
  (_, counters) <- runMyApp fileCount config ()
  (_, usages) <- runMyApp diskUsage config (0 :: FileOffset)
  let report = toText $
               buildEntries "Directory tree: " treeEntryBuilder dirs
               <> buildEntries "File Counter: " tabEntryBuilder counters
               <> buildEntries "File Space usage" tabEntryBuilder usages
  TIO.putStr report

buildEntries :: Builder -> (e -> Builder) -> [e] -> Builder
buildEntries title entryBuilder entries =
  unlinesB $ title : map entryBuilder entries
tabEntryBuilder :: TextShow s => (FilePath, s) -> Builder
tabEntryBuilder (fp, s) = showb s <> "\t" <> fromString fp

main :: IO ()
main = work $ AppConfig {basePath="../", maxDepth=1, extension=Nothing, followSymlinks=False}
