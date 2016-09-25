module Api exposing (Msg(..), getFilters, saveFilter)

import Http
import Task
import Model.Filter exposing (Filter, decodeFilters, decodeFilter, encodeFilter)
import Util


type Msg
    = FetchFailed Http.Error
    | FiltersFetched (List Filter)
    | FilterSaved Filter
    | FilterSavingFailed Http.Error


filtersUrl : String
filtersUrl =
    "api/filters"


getFilters : () -> Cmd Msg
getFilters _ =
    Http.get decodeFilters filtersUrl
        |> Task.perform FetchFailed FiltersFetched


saveFilter : Filter -> Cmd Msg
saveFilter =
    encodeFilter
        >> Util.httpPost decodeFilter filtersUrl
        >> Task.perform FilterSavingFailed FilterSaved
