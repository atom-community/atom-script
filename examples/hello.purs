module Hello where

import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

main :: forall t. Eff ("console" :: CONSOLE | t) Unit
main =
  log "Hello, World!"
