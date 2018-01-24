module Model exposing (..)

import RemoteData exposing (RemoteData)
import GraphQL.Client.Http as GraphQLClient


type Msg
    = NoOp
    | ReceiveQueryResponse (GraphQLData (List Recording))


type alias Model =
    { recordings : GraphQLData (List Recording)
    }


type alias GraphQLData a =
    RemoteData GraphQLClient.Error a


type alias Recording =
    { id : String
    , author : String
    , description : String
    }
