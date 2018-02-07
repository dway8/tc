module Requests exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Task exposing (Task)
import Model exposing (Msg(..), Recording, EditableData(..), RecordingId, Theme(..), themeToString, RecordingForm)
import Utils exposing (Coordinates)
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
            (list recordingSpec)
        )
        |> queryDocument
        |> request
            {}


fetchRecordingsCmd : Cmd Msg
fetchRecordingsCmd =
    sendQueryRequest fetchRecordingsQuery
        |> Task.attempt (RemoteData.fromResult >> ReceiveQueryResponse)


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
      , Arg.variable <|
            Var.required "coordinates"
                .coordinates
                (Var.object "coordinates"
                    [ Var.field "lat" .lat Var.float
                    , Var.field "lng" .lng Var.float
                    ]
                )
      )
    , ( "searchAddress", Arg.variable <| Var.required "searchAddress" (.searchAddress >> Maybe.withDefault "") Var.string )
    , ( "address", Arg.variable <| Var.required "address" (.address >> Maybe.withDefault "") Var.string )
    , ( "city", Arg.variable <| Var.required "city" (.city >> Maybe.withDefault "") Var.string )
    ]


recordingIdToInt : String -> Int
recordingIdToInt str =
    Result.withDefault 0 (String.toInt str)


recordingSpec : ValueSpec NonNull ObjectType Recording vars
recordingSpec =
    object Recording
        |> with (field "id" [] string)
        |> with (field "author" [] (nullable string))
        |> with (field "description" [] (nullable string))
        |> with
            (field "theme"
                []
                (extract (field "name" [] themeSpec))
            )
        |> with
            (field "coordinates"
                []
                (object Coordinates
                    |> with (field "lat" [] float)
                    |> with (field "lng" [] float)
                )
            )
        |> with (field "searchAddress" [] (nullable string))
        |> with (field "address" [] (nullable string))
        |> with (field "city" [] (nullable string))


themeSpec : ValueSpec NonNull EnumType Theme vars
themeSpec =
    enumWithDefault (always NoTheme)
        [ ( "Nature", Nature )
        , ( "Histoire", History )
        , ( "Culture", Culture )
        ]
