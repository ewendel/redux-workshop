module Model.GMaps exposing (GMPos, Marker, IconUrl)


type alias IconUrl = String


type alias GMPos =
    { lat : Float
    , lng : Float
    }


type alias Marker =
    { id : Int
    , pos : GMPos
    }
