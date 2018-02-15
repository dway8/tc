module AppPublic.Model exposing (..)

import Utils exposing (Coordinates, GraphQLData)
import Recording exposing (Recording)


type Msg
    = NoOp
    | ReceiveQueryResponse (GraphQLData (List Recording))


type alias Model =
    { recordings : GraphQLData (List Recording)
    , map : Map
    }


type alias Map =
    { zoom : Int
    , center : Coordinates
    , bounds : Maybe Bounds
    }


type alias Bounds =
    { nw : Coordinates
    , se : Coordinates
    }


initMap : Map
initMap =
    { zoom = 3
    , center = { lat = 0, lng = 0 }
    , bounds = Nothing
    }
