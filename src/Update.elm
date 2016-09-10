module Update
    exposing
        ( Msg(..)
        , update
        , init
        , subscriptions
        )

import WebSocket
import Model exposing (Model, maxTweets)
import Model.Route exposing (Route(..), routeToString)
import Model.Tweet exposing (Tweet, jsonDecodeTweetString)


init : ( Model, Cmd Msg )
init =
    ( { tweets = []
      , route = Main
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://twitterws.herokuapp.com" NewTweet


type Msg
    = NewTweet String
    | RouteChanged Route


updateTweets : Msg -> List Tweet -> List Tweet
updateTweets msg tweets =
    case msg of
        NewTweet tweetStr ->
            let
                tweetMb =
                    tweetStr
                        |> jsonDecodeTweetString
                        |> Result.toMaybe

                tweets =
                    case tweetMb of
                        Just t ->
                            t :: tweets

                        Nothing ->
                            tweets
            in
                tweets |> List.take maxTweets

        _ ->
            tweets


updateRoute : Msg -> Route -> Route
updateRoute msg route =
    case msg of
        RouteChanged r ->
            r

        _ ->
            route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model
        | tweets = updateTweets msg model.tweets
        , route = updateRoute msg model.route
      }
    , Cmd.none
    )
