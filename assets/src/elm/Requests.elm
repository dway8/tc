module Requests exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)
import Model exposing (Msg(..), Recording)
import RemoteData


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


sendMutationRequest : Request Mutation a -> Task GraphQLClient.Error a
sendMutationRequest request =
    GraphQLClient.sendMutation "/api" request


recordingsRequest : Request Query (List Recording)
recordingsRequest =
    extract
        (field "recordings"
            []
            (list
                (object Recording
                    |> with (field "id" [] string)
                    |> with (field "author" [] string)
                    |> with (field "description" [] string)
                )
            )
        )
        |> queryDocument
        |> request
            {}


sendRecordingsQuery : Cmd Msg
sendRecordingsQuery =
    sendQueryRequest recordingsRequest
        |> Debug.log "sending request"
        |> Task.attempt (RemoteData.fromResult >> ReceiveQueryResponse)
