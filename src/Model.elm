module Model exposing (Model, maxTweets)

import Model.Tweet exposing (Tweet)
import Model.Route exposing (Route)


maxTweets : Int
maxTweets =
    100


type alias Model =
    { tweets : List Tweet
    , route : Route
    }
