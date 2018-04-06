module Trip exposing (..)

import Recording exposing (Recording)


type alias Trip =
    { id : TripId
    , recordings : List Recording
    }


type alias TripId =
    String
