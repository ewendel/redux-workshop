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
import Model.Tweet exposing (Tweet, TweetId, jsonDecodeTweetString, toMarker)
import GMaps exposing (showMap, hideMap, showMarkers, markerClicked)
import Util


init : ( Model, Cmd Msg )
init =
    ( { tweets = []
      , route = Main
      , currentTweet = Nothing
      }
    , showMap ()
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WebSocket.listen "ws://twitterws.herokuapp.com" NewTweet
        , markerClicked MarkerClicked
        ]


type Msg
    = NewTweet String
    | RouteChanged Route
    | MarkerClicked TweetId


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


updateMarkerClicked : TweetId -> Model -> ( Model, Cmd Msg )
updateMarkerClicked tId model =
    let
        newCurrent =
            model.tweets
                |> List.filter (\t -> t.id == tId)
                |> List.head
                |> (\ct ->
                        if Util.maybeEquals ct model.currentTweet then
                            Nothing
                        else
                            ct
                   )
    in
        ( { model | currentTweet = newCurrent }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged r ->
            updateRoute r model

        NewTweet t ->
            updateTweets t model

        MarkerClicked m ->
            updateMarkerClicked m model |> Debug.log "Marker clicked"
