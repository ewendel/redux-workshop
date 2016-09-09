module Main exposing (..)

import Html exposing (div, text)
import Html.App as Html


type alias Model =
    Int


type Msg
    = NoOp


init : ( Model, Cmd a )
init =
    ( 1, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div [] [ text (toString model) ]


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
