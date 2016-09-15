port module GMaps exposing (Marker, showMap, hideMap, showMarkers)


type alias GMPos =
    { lat : Float
    , lng : Float
    }


type alias Marker =
    { id : Int
    , pos : GMPos
    }


port showMap : () -> Cmd a


port hideMap : () -> Cmd a


port showMarkers : List Marker -> Cmd a
