module Main where

import Prelude (bind, ($), Unit, discard)
import Control.Monad.Eff (Eff)
import DOM (DOM)
import DOM.Event.Types (Event)
import Pux (CoreEffects, EffModel, noEffects, start)
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onChange)
import Pux.Renderer.React (renderToDOM)

import Unsafe.Coerce (unsafeCoerce)
import Data.Maybe (Maybe(..), fromMaybe)

import Text.Smolder.HTML
import Text.Smolder.Markup (text, (#!))

import State (State, init)
import Editor as Editor


data Action
  = SetNotes Event -- We're using the Event type because that's what onChange expects, but actually it's a simple String.


foldp :: forall e. Action -> State -> EffModel State Action (dom :: DOM | e)
foldp (SetNotes ev) state = noEffects $ state { notes = Just notes' }
  where
    notes' :: String
    notes' = unsafeCoerce ev


view :: State -> HTML Action
view state =
  div $ do
    h3 $ text "A React component (react-quill)"
    Editor.component {value: fromMaybe "" state.notes} #! onChange (SetNotes) $ text ""
    h3 $ text "Contents of the editor"
    div $ text (fromMaybe "" state.notes)


main :: Eff (CoreEffects (dom :: DOM)) Unit
main = do
  app <- start
    { initialState: init
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input


