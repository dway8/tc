module AppPublic.Requests exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task)
import AppPublic.Model exposing (Msg(..))
import Recording exposing (Recording, RecordingId, Theme(..), themeToString, fetchRecordingsQuery, recordingSpec)
import RemoteData


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


sendMutationRequest : Request Mutation a -> Task GraphQLClient.Error a
sendMutationRequest request =
    GraphQLClient.sendMutation "/api" request


fetchRecordingsCmd : Cmd Msg
fetchRecordingsCmd =
    sendQueryRequest fetchRecordingsQuery
        |> Task.attempt (RemoteData.fromResult >> ReceiveQueryResponse)
