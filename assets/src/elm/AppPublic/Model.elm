module AppPublic.Model exposing (..)

import AppPublic.Ports exposing (InfoForElm)
import Recording exposing (Recording)
import Utils exposing (Coordinates, GraphQLData)


type Msg
    = NoOp
    | ReceiveQueryResponse (GraphQLData (List Recording))
    | InfoFromOutside InfoForElm
    | LogError String
    | CloseRecordingDialog


type alias Model =
    { recordings : GraphQLData (List Recording)
    , map : Map
    , shownRecording : Maybe Recording
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
