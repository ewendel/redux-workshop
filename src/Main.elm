module Main exposing (..)

import Html exposing (div, text)
import Html.App as Html
import WebSocket
import Json.Decode as Json
import Model exposing (Tweet, decodeTweet, exampleTweet)
import View


maxTweets : Int
maxTweets = 100


type alias Model =
    List Tweet


type Msg
    = NewTweet String


init : ( Model, Cmd a )
init =
    ( [], Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTweet tweetStr ->
            let
                tweetMb =
                    tweetStr
                        |> Json.decodeString decodeTweet
                        |> Result.toMaybe
                tweets =
                    case tweetMb of
                        Just t -> t :: model

                        Nothing -> model
            in
                ( tweets |> List.take maxTweets, Cmd.none )

view : Model -> Html.Html Msg
view model =
  View.tweetList model

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
