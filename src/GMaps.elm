port module GMaps exposing (showMap, hideMap, showMarkers, markerClicked)

import Model.GMaps exposing (Marker)
import Model.Tweet exposing (TweetId)


port showMap : () -> Cmd a


port hideMap : () -> Cmd a


port showMarkers : List Marker -> Cmd a


port markerClicked : (TweetId -> msg) -> Sub msg
