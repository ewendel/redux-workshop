module View exposing (tweet)

import Html exposing (div, img, span, strong, text)
import Html.Attributes exposing (class, src)
import Model exposing (Tweet)


tweet : Tweet -> Html.Html a
tweet model =
    div [ class "tweet" ]
        [ div [ class "tweet-header" ]
            [ img [ class "tweet-image", src "https://pbs.twimg.com/profile_images/553711083064541184/9VsY9i09.jpeg" ]
                []
            , div [ class "tweet-image-offset tweet-name" ]
                [ text "Dan Abramov" ]
            , div [ class "tweet-image-offset tweet-screen-name" ]
                [ text "@DanAbramov" ]
            ]
        , div [ class "tweet-content" ]
            [ div [ class "tweet-text" ]
                [ text "Good luck on your quest to learn Redux!" ]
            , div [ class "tweet-stats" ]
                [ span [ class "tweet-user-followers" ]
                    [ strong []
                        [ text "26 587" ]
                    , span [ class "tweet-stats-desc" ]
                        [ text "followers" ]
                    ]
                ]
            , span [ class "tweet-country tweet-stats-desc" ]
                [ text "UK" ]
            , div [ class "tweet-city tweet-stats-desc" ]
                [ text "London" ]
            ]
        ]
