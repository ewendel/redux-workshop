module Model.MarkerColor exposing (Color(..), defaultColor, toIconUrl, colorToString, colorToFriendlyName)

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


colorToFriendlyName : Color -> String
colorToFriendlyName color =
    case color of
        Yellow -> "Yellow"
        Blue -> "Blue"
        Green -> "Green"
        Lightblue -> "Light blue"
        Orange -> "Orange"
        Pink -> "Pink"
        Purple -> "Purple"
        Red -> "Red"


toIconUrl : Color -> IconUrl
toIconUrl color =
    "http://maps.google.com/mapfiles/ms/icons/" ++ (colorToString color) ++ "-dot.png"
