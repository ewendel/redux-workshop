module Model exposing (Model, maxTweets)

import Model.Tweet exposing (Tweet)
import Model.Route exposing (Route)
import Model.Filter exposing (Filter)
import Model.ApiData exposing (ApiData)
import Model.FilterForm exposing (FilterFormState)


maxTweets : Int
maxTweets =
    100


type alias Model =
    { tweets : List Tweet
    , route : Route
    , currentTweet : Maybe Tweet
    , filters : ApiData (List Filter)
    , formState : FilterFormState
    }
