module Utils exposing (..)

import Task
import RemoteData exposing (RemoteData)
import GraphQL.Client.Http as GraphQLClient


emitMsg : msg -> Cmd msg
emitMsg msg =
    msg
        |> Task.succeed
        |> Task.perform identity


type alias Coordinates =
    { lat : Float, lng : Float }


type alias GraphQLData a =
    RemoteData GraphQLClient.Error a
