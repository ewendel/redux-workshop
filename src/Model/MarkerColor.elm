module Model.MarkerColor exposing (Color(..), defaultColor, toIconUrl)

import Model.GMaps exposing (IconUrl)


type Color
    = Yellow
    | Blue
    | Green
    | Lightblue
    | Orange
    | Pink
    | Purple
    | Red


defaultColor : Color
defaultColor = Red


toIconUrl : Color -> IconUrl
toIconUrl color =
    let
        colorStr =
            case color of
                Yellow -> "yellow"
                Blue -> "blue"
                Green -> "green"
                Lightblue -> "lightblue"
                Orange -> "orange"
                Pink -> "pink"
                Purple -> "purple"
                Red -> "red"
    in
        "http://maps.google.com/mapfiles/ms/icons/" ++ colorStr ++ "-dot.png"
