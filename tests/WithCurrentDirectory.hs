{-# LANGUAGE CPP #-}
module WithCurrentDirectory where
#include "util.inl"
import Data.List (sort)
import System.Directory
import System.FilePath ((</>))

main :: TestEnv -> IO ()
main _t = do
  createDirectory dir
  -- Make sure we're starting empty
  T(expectEq) () [] . sort =<< getDirectoryContentsA dir
  cwd <- getCurrentDirectory
  withCurrentDirectory dir (writeFile testfile contents)
  -- Are we still in original directory?
  T(expectEq) () cwd =<< getCurrentDirectory
  -- Did the test file get created?
  T(expectEq) () [testfile] . sort =<< getDirectoryContentsA dir
  -- Does the file contain what we expected to write?
  T(expectEq) () contents =<< readFile (dir </> testfile)
  where
    testfile = "testfile"
    contents = "some data\n"
    dir = "dir"
