module Editor where

import React (ReactClass)
import Pux.Renderer.React (reactClassWithProps)


foreign import fromReact :: ∀ props. ReactClass props

component = reactClassWithProps fromReact "Editor"
