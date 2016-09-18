module Model exposing (Model, maxTweets)

import Model.Tweet exposing (Tweet)
import Model.Route exposing (Route)
import Model.Filter exposing (Filter)


maxTweets : Int
maxTweets =
    100


type alias Model =
    { tweets : List Tweet
    , route : Route
    , currentTweet : Maybe Tweet
    , filters : List Filter
    , formVisible : Bool
    , formState : Filter
    }
