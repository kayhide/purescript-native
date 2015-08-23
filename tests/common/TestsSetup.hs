-----------------------------------------------------------------------------
--
-- Module      :  Main
-- License     :  MIT (http://opensource.org/licenses/MIT)
--
-- Maintainer  :  Phil Freeman <paf31@cantab.net>
-- Stability   :  experimental
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------
module TestsSetup where

import Data.Maybe (fromMaybe)
import Control.Applicative

import Control.Monad

import Control.Applicative

import Control.Monad.Trans.Maybe

import System.Process
import System.Directory

findNodeProcess :: IO (Maybe String)
findNodeProcess = runMaybeT . msum $ map (MaybeT . findExecutable) names
  where
  names = ["nodejs", "node"]

fetchSupportCode :: IO ()
fetchSupportCode = do
  node <- fromMaybe (error "cannot find node executable") <$> findNodeProcess
  setCurrentDirectory "tests/support"
  callProcess "npm" ["install"]
  -- Sometimes we run as a root (e.g. in simple docker containers)
  -- And we are non-interactive: https://github.com/bower/bower/issues/1162
  callProcess "node_modules/.bin/bower" ["--allow-root", "install", "--config.interactive=false"]
  callProcess node ["setup.js"]
  setCurrentDirectory "../.."
