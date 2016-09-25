module Util exposing (collect, maybeEquals, find, httpErrorToString, httpPost)

import Http
import Json.Encode
import Json.Decode
import Task


collect : List (Maybe a) -> List a
collect list =
    case list of
        (Just h) :: t ->
            h :: (collect t)

        Nothing :: t ->
            collect t

        [] ->
            []


maybeEquals : Maybe a -> Maybe a -> Bool
maybeEquals aMb bMb =
    case ( aMb, bMb ) of
        ( Just a, Just b ) ->
            a == b

        _ ->
            False


find : (a -> Bool) -> List a -> Maybe a
find f =
    List.filter f >> List.head


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.UnexpectedPayload str ->
            "Unexpected payload: " ++ str

        Http.BadResponse code str ->
            "Bad response (" ++ toString code ++ "): " ++ str


{-| This function is useful as Http.post does not send the body as application/json per default,
   nor does it expose a simple way of specifying Content-Type.
-}
httpPost : Json.Decode.Decoder b -> String -> Json.Encode.Value -> Task.Task Http.Error b
httpPost decoder url jsonValue =
    Http.send Http.defaultSettings
        { verb = "POST"
        , headers =
            [ ( "Content-Type", "application/json" )
            , ( "Accept", "application/json" )
            ]
        , url = url
        , body = Http.string (Json.Encode.encode 0 jsonValue)
        }
        |> Http.fromJson decoder
