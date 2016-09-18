module Model.Filter exposing (Filter, findFilterMatch, emptyFilter)

import Model.MarkerColor exposing (Color(..))
import Model.Tweet exposing (Tweet)
import String
import Util


type alias Filter =
    { color : Color
    , name : String
    , text : String
    , hashtags : List String
    , active : Bool
    }


emptyFilter : Filter
emptyFilter =
    Filter Pink "" "" [] True


matchesFilter : Tweet -> Filter -> Bool
matchesFilter tweet filter =
    let
        rules =
            [ (\t ->
                not (String.isEmpty filter.text) && (t.text |> String.contains filter.text)
              )
            , (\t ->
                t.entities.hashtags
                    |> List.map .text
                    |> List.any
                        (\ht ->
                            List.member ht filter.hashtags
                        )
              )
            ]
    in
        if not filter.active then
            False
        else
            rules
                |> List.any (\f -> f tweet)


findFilterMatch : List Filter -> Tweet -> Maybe Filter
findFilterMatch filters tweet =
    filters
        |> Util.find (matchesFilter tweet)
