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
import Model.Filter exposing (Filter, findFilterMatch)
import GMaps exposing (showMap, hideMap, showMarkers, changeMarkerIcon, markerClicked)
import Util


init : ( Model, Cmd Msg )
init =
    ( { tweets = []
      , route = Main
      , currentTweet = Nothing
      , filters =
            [ { color = MarkerColor.Yellow
              , filterName = "The"
              , text = "the"
              , hashtags = [ "the" ]
              , active = True
              }
            ]
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
    | ToggleFilterActive Filter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged r ->
            updateRoute r model

        NewTweet t ->
            addTweet t model

        MarkerClicked m ->
            setCurrentTweet m model

        ToggleFilterActive f ->
            toggleFilterActive f model


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


setCurrentTweet : TweetId -> Model -> ( Model, Cmd Msg )
setCurrentTweet tId model =
    let
        newCurrentTweet =
            model.tweets
                |> Util.find (\t -> t.id == tId)
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


tweetToMarker : Tweet -> Color -> ( Marker, IconUrl )
tweetToMarker tweet color =
    ( toMarker tweet, toIconUrl color )


updateMarkers : Model -> Model -> Cmd Msg
updateMarkers oldModel newModel =
    if
        oldModel.tweets
            == newModel.tweets
            && oldModel.currentTweet
            == newModel.currentTweet
            && oldModel.filters
            == newModel.filters
    then
        Cmd.none
    else
        let
            getColor tweet =
                if Util.maybeEquals (Just tweet) newModel.currentTweet then
                    MarkerColor.Blue
                else
                    tweet
                        |> findFilterMatch newModel.filters
                        |> Maybe.map .color
                        |> Maybe.withDefault defaultColor

            showMarkersCmd =
                newModel.tweets
                    |> List.map (\t -> ( toMarker t, toIconUrl <| getColor t ))
                    |> showMarkers
        in
            showMarkersCmd


toggleFilterActive : Filter -> Model -> ( Model, Cmd Msg )
toggleFilterActive filter model =
    let
        updatedFilters =
            model.filters
                |> List.map
                    (\f ->
                        if f == filter then
                            { f | active = not f.active }
                        else
                            f
                    )
    in
        ( { model | filters = updatedFilters }
        , Cmd.none
        )
