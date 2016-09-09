module Main exposing (..)

import Html exposing (div, text)
import Html.App as Html
import WebSocket
import Json.Decode as Json
import Model exposing (Tweet, decodeTweet, exampleTweet)
import View


type alias Model =
    Maybe Tweet


type Msg
    = NewTweet String


init : ( Model, Cmd a )
init =
    ( Nothing, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTweet tweetStr ->
            let
                tweet =
                    tweetStr
                        |> Json.decodeString decodeTweet
                        |> Result.toMaybe
            in
                ( tweet, Cmd.none )


view : Model -> Html.Html Msg
view model =
    case model of
        Just tweet ->
            View.tweet tweet

        Nothing ->
            div [] []


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://twitterws.herokuapp.com" NewTweet


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
