module Util exposing (collect, maybeEquals)


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
