module Model.ApiData exposing (ApiData(..), map, withDefault)


type ApiData a
    = NotLoaded
    | Loading
    | Loaded a
    | Failed String


map : (a -> a) -> ApiData a -> ApiData a
map f data =
    case data of
        Loaded existing ->
            Loaded (f existing)

        _ ->
            data


withDefault : a -> ApiData a -> a
withDefault val data =
    case data of
        Loaded existing ->
            existing

        _ ->
            val
