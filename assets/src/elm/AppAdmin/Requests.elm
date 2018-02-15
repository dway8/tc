module AppAdmin.Requests exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Task exposing (Task)
import AppAdmin.Model exposing (Msg(..), EditableData(..), RecordingForm)
import Recording exposing (Recording, RecordingId, Theme(..), themeToString, fetchRecordingsQuery, recordingSpec)
import RemoteData


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    GraphQLClient.sendQuery "/api" request


sendMutationRequest : Request Mutation a -> Task GraphQLClient.Error a
sendMutationRequest request =
    GraphQLClient.sendMutation "/api" request


deleteRecordingCmd : RecordingId -> Cmd Msg
deleteRecordingCmd id =
    sendMutationRequest (deleteRecordingMutation id)
        |> Task.attempt (RemoteData.fromResult >> DeleteRecordingResponse)


saveRecordingCmd : EditableData RecordingForm -> Cmd Msg
saveRecordingCmd form =
    case form of
        Editing f ->
            let
                mutation =
                    if f.recording.id == "NEW" then
                        createRecordingMutation f.recording
                    else
                        saveRecordingMutation f.recording
            in
                sendMutationRequest mutation
                    |> Task.attempt (RemoteData.fromResult >> SaveRecordingResponse)

        _ ->
            Cmd.none


deleteRecordingMutation : RecordingId -> Request Mutation RecordingId
deleteRecordingMutation id =
    extract
        (field "deleteRecording"
            [ ( "id", Arg.variable <| Var.required "id" .id Var.int )
            ]
            (extract (field "id" [] string))
        )
        |> mutationDocument
        |> request { id = recordingIdToInt id }


createRecordingMutation : Recording -> Request Mutation Recording
createRecordingMutation r =
    extract
        (field "createRecording"
            recordingArgs
            (recordingSpec)
        )
        |> mutationDocument
        |> request r


saveRecordingMutation : Recording -> Request Mutation Recording
saveRecordingMutation r =
    extract
        (field "updateRecording"
            [ ( "id", Arg.variable <| Var.required "id" (.id >> recordingIdToInt) Var.int )
            , ( "recording"
              , Arg.object recordingArgs
              )
            ]
            (recordingSpec)
        )
        |> mutationDocument
        |> request r


recordingArgs : List ( String, Arg.Value Recording )
recordingArgs =
    [ ( "author", Arg.variable <| Var.required "author" (.author >> Maybe.withDefault "") Var.string )
    , ( "description", Arg.variable <| Var.required "description" (.description >> Maybe.withDefault "") Var.string )
    , ( "theme", Arg.variable <| Var.required "theme" (.theme >> themeToString) Var.string )
    , ( "coordinates"
      , Arg.object
            [ ( "lat", Arg.variable <| Var.required "lat" (.coordinates >> .lat) Var.float )
            , ( "lng", Arg.variable <| Var.required "lng" (.coordinates >> .lng) Var.float )
            ]
      )
    , ( "searchAddress", Arg.variable <| Var.required "searchAddress" (.searchAddress >> Maybe.withDefault "") Var.string )
    , ( "address", Arg.variable <| Var.required "address" (.address >> Maybe.withDefault "") Var.string )
    , ( "city", Arg.variable <| Var.required "city" (.city >> Maybe.withDefault "") Var.string )
    ]


recordingIdToInt : String -> Int
recordingIdToInt str =
    Result.withDefault 0 (String.toInt str)


fetchRecordingsCmd : Cmd Msg
fetchRecordingsCmd =
    sendQueryRequest fetchRecordingsQuery
        |> Task.attempt (RemoteData.fromResult >> ReceiveQueryResponse)
