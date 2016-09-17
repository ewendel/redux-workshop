module Util exposing (maybeEquals)


maybeEquals : Maybe a -> Maybe a -> Bool
maybeEquals aMb bMb =
    case ( aMb, bMb ) of
        ( Just a, Just b ) ->
            a == b

        _ ->
            False
