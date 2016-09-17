module Model.Filter exposing (Filter, findFilterMatch)

import Model.MarkerColor exposing (Color)
import Model.Tweet exposing (Tweet)
import String
import Util


type alias Filter =
    { color : Color
    , filterName : String
    , text : String
    , hashtags : List String
    , active : Bool
    }


matchesFilter : Tweet -> Filter -> Bool
matchesFilter tweet filter =
    let
        rules =
            [ (\t -> t.text |> String.contains filter.text)
            , (\t ->
                  t.entities.hashtags
                      |> List.map .text
                      |> List.any (\ht ->
                          List.member ht filter.hashtags
                      )
              )
            ]
    in
        rules
            |> List.any (\f -> f tweet)


findFilterMatch : List Filter -> Tweet -> Maybe Filter
findFilterMatch filters tweet =
    filters
        |> Util.find (matchesFilter tweet)
