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
import Model.GMaps exposing (Marker, IconUrl)
import Model.MarkerColor as MarkerColor exposing (Color, defaultColor, toIconUrl)
import GMaps exposing (showMap, hideMap, showMarkers, changeMarkerIcon, markerClicked)
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


tweetToMarker : Tweet -> Color -> ( Marker, IconUrl )
tweetToMarker tweet color =
    ( toMarker tweet, toIconUrl color )


updateMarkers : Model -> Model -> Cmd Msg
updateMarkers oldModel newModel =
    if oldModel.tweets == newModel.tweets && oldModel.currentTweet == newModel.currentTweet then
        Cmd.none
    else
        [ Just <| showMarkers (newModel.tweets |> List.map (\t -> tweetToMarker t defaultColor))
        , getColorChangeCmd oldModel newModel
        ]
            |> Util.collect
            |> Cmd.batch


getColorChangeCmd : Model -> Model -> Maybe (Cmd Msg)
getColorChangeCmd oldModel newModel =
    case ( oldModel.currentTweet, newModel.currentTweet ) of
        ( Nothing, Nothing ) ->
            Nothing

        ( Just t1, Just t2 ) ->
            if t1 == t2 then
                Nothing
            else
                Just <|
                    Cmd.batch
                        [ changeMarkerIcon ( t1.id, toIconUrl defaultColor )
                        , changeMarkerIcon ( t2.id, toIconUrl MarkerColor.Blue )
                        ]

        ( Just t, Nothing ) ->
            Just <| changeMarkerIcon ( t.id, toIconUrl defaultColor )

        ( Nothing, Just t ) ->
            Just <| changeMarkerIcon ( t.id, toIconUrl MarkerColor.Blue )


addTweet : String -> Model -> ( Model, Cmd Msg )
addTweet tweetStr model =
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

        updatedModel =
            { model
                | tweets = List.take maxTweets tweets
            }
    in
        ( updatedModel
        , updateMarkers model updatedModel
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


setCurrentMarker : TweetId -> Model -> ( Model, Cmd Msg )
setCurrentMarker tId model =
    let
        newCurrentTweet =
            model.tweets
                |> List.filter (\t -> t.id == tId)
                |> List.head
                |> (\ct ->
                        if Util.maybeEquals ct model.currentTweet then
                            Nothing
                        else
                            ct
                   )

        updatedModel =
            { model | currentTweet = newCurrentTweet }
    in
        ( updatedModel
        , updateMarkers model updatedModel
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged r ->
            updateRoute r model

        NewTweet t ->
            addTweet t model

        MarkerClicked m ->
            setCurrentMarker m model
