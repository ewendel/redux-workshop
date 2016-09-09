module Main exposing (..)

import Html exposing (div, text)
import Html.App as Html
import Model exposing (Tweet, exampleTweet)
import View


type alias Model =
    Tweet


type Msg
    = NoOp


init : ( Model, Cmd a )
init =
    ( exampleTweet, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    View.tweet model

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
