port module GMaps exposing (showMap, hideMap, showMarkers, markerClicked, changeMarkerIcon)

import Model.GMaps exposing (Marker, IconUrl)
import Model.Tweet exposing (TweetId)


port showMap : () -> Cmd a


port hideMap : () -> Cmd a


port showMarkers : List ( Marker, IconUrl ) -> Cmd a


port changeMarkerIcon : ( TweetId, IconUrl ) -> Cmd a


port markerClicked : (TweetId -> msg) -> Sub msg
