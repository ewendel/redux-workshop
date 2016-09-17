module Model.MarkerColor exposing (Color(..), defaultColor, toIconUrl, colorToString)

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


colorToString : Color -> String
colorToString color =
    case color of
        Yellow -> "yellow"
        Blue -> "blue"
        Green -> "green"
        Lightblue -> "lightblue"
        Orange -> "orange"
        Pink -> "pink"
        Purple -> "purple"
        Red -> "red"


toIconUrl : Color -> IconUrl
toIconUrl color =
    "http://maps.google.com/mapfiles/ms/icons/" ++ (colorToString color) ++ "-dot.png"
