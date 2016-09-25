module Model.Filter exposing (Filter, findFilterMatch, emptyFilter, decodeFilters, decodeFilter, encodeFilters, encodeFilter)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline
import Model.MarkerColor exposing (Color(..), decodeColor, encodeColor)
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


decodeFilter : Json.Decode.Decoder Filter
decodeFilter =
    Json.Decode.Pipeline.decode Filter
        |> Json.Decode.Pipeline.required "color" (decodeColor)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "hashtags" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "active" (Json.Decode.bool)


decodeFilters : Json.Decode.Decoder (List Filter)
decodeFilters =
    Json.Decode.list decodeFilter


encodeFilter : Filter -> Json.Encode.Value
encodeFilter filter =
    Json.Encode.object
        [ ( "color", encodeColor filter.color )
        , ( "name", Json.Encode.string filter.name )
        , ( "text", Json.Encode.string filter.text )
        , ( "hashtags", Json.Encode.list (List.map Json.Encode.string filter.hashtags) )
        , ( "active", Json.Encode.bool filter.active )
        ]


encodeFilters : List Filter -> Json.Encode.Value
encodeFilters filters =
    Json.Encode.list (List.map encodeFilter filters)
