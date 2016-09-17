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
import Model.Filter exposing (Filter)
import GMaps exposing (showMap, hideMap, showMarkers, changeMarkerIcon, markerClicked)
import Util


init : ( Model, Cmd Msg )
init =
    ( { tweets = []
      , route = Main
      , currentTweet = Nothing
      , filters =
            [ { color = MarkerColor.Yellow
              , filterName = "Trump"
              , text = "trump"
              , hashtags = [ "trump" ]
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


tweetToMarker : Tweet -> Color -> ( Marker, IconUrl )
tweetToMarker tweet color =
    ( toMarker tweet, toIconUrl color )


updateMarkers : Model -> Model -> Cmd Msg
updateMarkers oldModel newModel =
    if oldModel.tweets == newModel.tweets && oldModel.currentTweet == newModel.currentTweet then
        Cmd.none
    else
        let
            showMarkersCmd =
                newModel.tweets
                    |> List.map (\t -> ( toMarker t, toIconUrl defaultColor ))
                    |> showMarkers
        in
            [ Just showMarkersCmd
            , getColorChangeCmd oldModel newModel
            ]
                |> Util.collect
                |> Cmd.batch


getColorChangeCmd : Model -> Model -> Maybe (Cmd Msg)
getColorChangeCmd oldModel newModel =
    case ( oldModel.currentTweet, newModel.currentTweet ) of
        ( Nothing, Nothing ) ->
            Nothing

        ( Just t1, Nothing ) ->
            Just <| changeMarkerIcon ( t1.id, toIconUrl defaultColor )

        ( Nothing, Just t2 ) ->
            Just <| changeMarkerIcon ( t2.id, toIconUrl MarkerColor.Blue )

        ( Just t1, Just t2 ) ->
            if t1 == t2 then
                Nothing
            else
                Just <|
                    Cmd.batch
                        [ changeMarkerIcon ( t1.id, toIconUrl defaultColor )
                        , changeMarkerIcon ( t2.id, toIconUrl MarkerColor.Blue )
                        ]


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
