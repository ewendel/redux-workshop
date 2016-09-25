module Model.FilterForm exposing (FilterFormState(..))

import Model.Filter exposing (Filter)


type FilterFormState
    = Hidden
    | Editing Filter
    | Saving
    | SavingFailed String
