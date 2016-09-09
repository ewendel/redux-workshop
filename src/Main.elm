module Main exposing (..)

import Html exposing (div, text)
import Html.Attributes exposing (class)
import Html.App as Html
import Mouse


type alias Model =
    Int


type Msg
    = MouseClick Mouse.Position


init : ( Model, Cmd a )
init =
    ( 1, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseClick _ ->
            ( model + 1, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div
        [ class "yellow-counter" ]
        [ text (toString model) ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.clicks MouseClick


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
