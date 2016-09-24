module Api exposing (Msg(..), getFilters)

import Http
import Task
import Model.Filter exposing (Filter, decodeFilters)


type Msg
    = FetchFailed Http.Error
    | FiltersFetched (List Filter)


getFilters : () -> Cmd Msg
getFilters _ =
    Http.get decodeFilters "api/filters"
        |> Task.perform FetchFailed FiltersFetched
