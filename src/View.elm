module View exposing (app)

import Html exposing (div, img, span, strong, text, ul, li, h1, a)
import Html.Attributes exposing (class, src, href, classList)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Model.Tweet exposing (Tweet)
import Model.Route as Route exposing (Route, routeToString)
import Model.Filter exposing (Filter)
import Model.MarkerColor exposing (colorToString)
import Update exposing (Msg)
import Util


app : Model -> Html.Html Msg
app model =
    let
        body =
            case model.route of
                Route.Main ->
                    viewMain model

                Route.Feed ->
                    viewFeed model
    in
        div []
            [ appHeader
            , body
            ]


appHeader : Html.Html Msg
appHeader =
    div [ class "app-header" ]
        [ div []
            [ h1 [ class "heading" ]
                [ text "Twitter ELM STUFF" ]
            , div [ class "menu-item" ]
                [ link Route.Main
                , link Route.Feed
                ]
            ]
        ]


viewMain : Model -> Html.Html Msg
viewMain model =
    let
        children =
            [ Maybe.map currentTweet model.currentTweet
            , Just <| filterList model.filters
            ]
                |> Util.collect
    in
        div []
            children


viewFeed : Model -> Html.Html Msg
viewFeed model =
    tweetList model.tweets


tweetList : List Tweet -> Html.Html a
tweetList tweets =
    let
        tweetListItems =
            tweets
                |> List.map (\t -> li [] [ tweet t ])
    in
        ul [ class "tweetlist" ]
            tweetListItems


tweet : Tweet -> Html.Html a
tweet model =
    div [ class "tweet" ]
        [ div [ class "tweet-header" ]
            [ img [ class "tweet-image", src model.user.profile_image_url_https ]
                []
            , div [ class "tweet-image-offset tweet-name" ]
                [ text model.user.name ]
            , div [ class "tweet-image-offset tweet-screen-name" ]
                [ text model.user.screen_name ]
            ]
        , div [ class "tweet-content" ]
            [ div [ class "tweet-text" ]
                [ text model.text ]
            , div [ class "tweet-stats" ]
                [ span [ class "tweet-user-followers" ]
                    [ strong []
                        [ text (toString model.user.followers_count) ]
                    , span [ class "tweet-stats-desc" ]
                        [ text "followers" ]
                    ]
                ]
            , span [ class "tweet-country tweet-stats-desc" ]
                [ text model.place.country_code ]
            , div [ class "tweet-city tweet-stats-desc" ]
                [ text model.place.name ]
            ]
        ]


currentTweet : Tweet -> Html.Html a
currentTweet t =
    div [ class "current-tweet" ]
        [ tweet t ]


link : Route -> Html.Html Msg
link route =
    let
        className =
            classList
                [ ( "img img-icon ", True )
                , ( "img-icon-settings", route == Route.Main )
                , ( "img-icon-dashboard", route == Route.Feed )
                ]
    in
        a
            [ href ("#" ++ (routeToString route))
            , className
            , onClick (Update.RouteChanged route)
            ]
            []


filterList : List Filter -> Html.Html Msg
filterList filters =
    div [ class "filter-container" ]
        [ ul [ class "filterList" ]
            (List.map (\f -> li [] [ filter f ]) filters)
        ]


filter : Filter -> Html.Html Msg
filter f =
    let
        containerClass =
            classList [ ( "inactive", not f.active ) ]
    in
        div
            [ containerClass
            , onClick (Update.ToggleFilterActive f)
            ]
            [ div [ class <| "circle " ++ (colorToString f.color) ] []
            , text f.filterName
            ]
