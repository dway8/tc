module AppPublic.Model exposing (..)

import RemoteData exposing (RemoteData)
import Element.Input as Input
import Utils exposing (Coordinates, GraphQLData)
import Recording exposing (Recording)


type Msg
    = NoOp
    | ReceiveQueryResponse (GraphQLData (List Recording))


type alias Model =
    { recordings : GraphQLData (List Recording)
    }
