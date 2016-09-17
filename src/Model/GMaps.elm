module Model.GMaps exposing (GMPos, Marker)


type alias GMPos =
    { lat : Float
    , lng : Float
    }


type alias Marker =
    { id : Int
    , pos : GMPos
    }
