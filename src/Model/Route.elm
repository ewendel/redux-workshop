module Model.Route exposing (Route(..), routeToString)


type Route
    = Main
    | Feed


routeToString : Route -> String
routeToString route =
    case route of
        Main ->
            "/"

        Feed ->
            "/feed"
