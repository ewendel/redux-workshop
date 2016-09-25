module View exposing (app)

import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import String
import Model exposing (Model)
import Model.Tweet exposing (Tweet)
import Model.Route as Route exposing (Route, routeToString)
import Model.Filter exposing (Filter)
import Model.MarkerColor exposing (Color(..), colorToString, colorToFriendlyName, colorFromString)
import Model.ApiData as ApiData
import Model.FilterForm as FilterFormState
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
            [ Just <| div [] [ filterContainer model ]
            , Maybe.map currentTweet model.currentTweet
            ]
                |> Util.collect
    in
        div [ class "map" ]
            children


viewFeed : Model -> Html.Html Msg
viewFeed model =
    div []
        [ div [ class "menu" ]
            [ filterContainer model ]
        , div [ class "feed" ]
            [ tweetList model.tweets ]
        ]


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


filterContainer : Model -> Html.Html Msg
filterContainer model =
    let
        addButton =
            button [ onClick Update.ShowForm ]
                [ text "New filter" ]

        formStuff =
            case model.formState of
                FilterFormState.Hidden ->
                    addButton

                FilterFormState.Editing f ->
                    filterForm f

                FilterFormState.Saving ->
                    div [] [ text "Saving..." ]

                FilterFormState.SavingFailed err ->
                    div []
                        [ text err
                        , addButton
                        ]
    in
        div [ class "filter-container" ]
            [ h2 [] [ text "Filters" ]
            , filterList model.filters
            , formStuff
            ]


filterList : ApiData.ApiData (List Filter) -> Html.Html Msg
filterList filters =
    case filters of
        ApiData.Loaded fs ->
            ul [ class "filterList" ]
                (List.map (\f -> li [] [ filter f ]) fs)

        ApiData.Loading ->
            div [] [ text "Loading..." ]

        ApiData.NotLoaded ->
            div [] []

        ApiData.Failed err ->
            div [] [ text err ]


filter : Filter -> Html.Html Msg
filter f =
    div
        [ classList [ ( "inactive", not f.active ) ]
        , onClick (Update.ToggleFilterActive f)
        ]
        [ div [ class <| "circle " ++ (colorToString f.color) ] []
        , text f.name
        ]


filterForm : Filter -> Html.Html Msg
filterForm f =
    let
        hashtags =
            f.hashtags
                |> String.concat

        handleColorChange : String -> Msg
        handleColorChange =
            colorFromString
                >> Maybe.withDefault Yellow
                >> (\c -> Update.ChangeFormState { f | color = c })
    in
        Html.form
            [ class "filter-form"
            , onSubmit (Update.FormSubmit f)
            ]
            [ h3 [] [ text "New filter" ]
            , textInput f.name "Name" "name" (\s -> Update.ChangeFormState { f | name = s })
            , textInput hashtags "#" "hashtag" (\s -> Update.ChangeFormState { f | hashtags = String.split " " s })
            , textInput f.text "Text" "text" (\s -> Update.ChangeFormState { f | text = s })
            , div [ class "input-wrapper" ]
                [ label [ for "color" ] [ text "Marker color" ]
                , select
                    [ name "color"
                    , onInput handleColorChange
                    ]
                    colorOptions
                ]
            , button [] [ text "Save" ]
            ]


textInput : String -> String -> String -> (String -> Msg) -> Html.Html Msg
textInput val name id f =
    div [ class "input-wrapper" ]
        [ label [ for id ] [ text name ]
        , input
            [ type' "text"
            , Attrs.id id
            , onInput f
            , value val
            ]
            []
        ]


colorOptions : List (Html.Html a)
colorOptions =
    let
        opt color =
            option
                [ value <| colorToString color ]
                [ text <| colorToFriendlyName color ]
    in
        [ opt Yellow
        , opt Green
        , opt Lightblue
        , opt Orange
        , opt Pink
        , opt Purple
        ]
