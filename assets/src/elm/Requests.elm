module Requests exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Task exposing (Task)
import Model exposing (Msg(..), Recording, EditableData(..))
import RemoteData


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


sendMutationRequest : Request Mutation a -> Task GraphQLClient.Error a
sendMutationRequest request =
    GraphQLClient.sendMutation "/api" request


fetchRecordingsQuery : Request Query (List Recording)
fetchRecordingsQuery =
    extract
        (field "recordings"
            []
            (list
                (object Recording
                    |> with (field "id" [] string)
                    |> with (field "author" [] (nullable string))
                    |> with (field "description" [] (nullable string))
                )
            )
        )
        |> queryDocument
        |> request
            {}


fetchRecordingsCmd : Cmd Msg
fetchRecordingsCmd =
    sendQueryRequest fetchRecordingsQuery
        |> Task.attempt (RemoteData.fromResult >> ReceiveQueryResponse)


saveRecordingCmd : EditableData Recording -> Cmd Msg
saveRecordingCmd form =
    case form of
        Editing r ->
            sendMutationRequest (saveRecordingMutation r)
                |> Task.attempt (RemoteData.fromResult >> SaveRecordingResponse)

        _ ->
            Cmd.none


saveRecordingMutation : Recording -> Request Mutation Recording
saveRecordingMutation r =
    extract
        (field "updateRecording"
            [ ( "id", Arg.variable <| Var.required "id" (.id >> recordingIdToInt) Var.int )
            , ( "recording"
              , Arg.object
                    [ ( "author", Arg.variable <| Var.required "author" (.author >> Maybe.withDefault "") Var.string )
                    , ( "description", Arg.variable <| Var.required "description" (.description >> Maybe.withDefault "") Var.string )
                    ]
              )
            ]
            (recordingSpec)
        )
        |> mutationDocument
        |> request r


recordingIdToInt : String -> Int
recordingIdToInt str =
    Result.withDefault 0 (String.toInt str)


recordingSpec : ValueSpec NonNull ObjectType Recording vars
recordingSpec =
    object Recording
        |> with (field "id" [] string)
        |> with (field "author" [] (nullable string))
        |> with (field "description" [] (nullable string))
