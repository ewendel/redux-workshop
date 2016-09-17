module Model.Filter exposing (Filter)

import Model.MarkerColor exposing (Color)


type alias Filter =
    { color : Color
    , filterName : String
    , text : String
    , hashtags : List String
    , active : Bool
    }
