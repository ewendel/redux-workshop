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
import Model.Tweet exposing (Tweet, jsonDecodeTweetString, toMarker)
import GMaps exposing (showMap, hideMap, showMarkers)


init : ( Model, Cmd Msg )
init =
    ( { tweets = []
      , route = Main
      }
    , showMap ()
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://twitterws.herokuapp.com" NewTweet


type Msg
    = NewTweet String
    | RouteChanged Route


updateTweets : String -> Model -> ( Model, Cmd Msg )
updateTweets tweetStr model =
    let
        tweetMb =
            tweetStr
                |> jsonDecodeTweetString
                |> Result.toMaybe

        tweets =
            case tweetMb of
                Just t ->
                    t :: model.tweets

                Nothing ->
                    model.tweets

        newTweets =
            tweets
                |> List.take maxTweets

        tweetMarkers =
            newTweets
                |> List.map toMarker
    in
        ( { model
            | tweets = newTweets
          }
        , showMarkers tweetMarkers
        )


updateRoute : Route -> Model -> ( Model, Cmd Msg )
updateRoute r model =
    case r of
        Main ->
            ( { model | route = r }
            , showMap ()
            )

        Feed ->
            ( { model | route = r }
            , hideMap ()
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged r ->
            updateRoute r model

        NewTweet t ->
            updateTweets t model
