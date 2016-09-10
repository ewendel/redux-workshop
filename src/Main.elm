module Main exposing (..)

import Html.App as Html
import View
import Update


main : Program Never
main =
    Html.program
        { init = Update.init
        , update = Update.update
        , view = View.app
        , subscriptions = Update.subscriptions
        }
