module Requests exposing (..)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Task exposing (Task)
import Model exposing (Msg(..), Recording, EditableData(..), RecordingId, Theme(..), themeToString)
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


saveRecordingCmd : EditableData Recording -> Cmd Msg
saveRecordingCmd form =
    case form of
        Editing r ->
            let
                mutation =
                    if r.id == "NEW" then
                        createRecordingMutation r
                    else
                        saveRecordingMutation r
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
            [ ( "author", Arg.variable <| Var.required "author" (.author >> Maybe.withDefault "") Var.string )
            , ( "description", Arg.variable <| Var.required "description" (.description >> Maybe.withDefault "") Var.string )
            , ( "theme", Arg.variable <| Var.required "theme" (.theme >> themeToString) Var.string )
            ]
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
              , Arg.object
                    [ ( "author", Arg.variable <| Var.required "author" (.author >> Maybe.withDefault "") Var.string )
                    , ( "description", Arg.variable <| Var.required "description" (.description >> Maybe.withDefault "") Var.string )
                    , ( "theme", Arg.variable <| Var.required "theme" (.theme >> themeToString) Var.string )
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
        |> with
            (field "theme"
                []
                (extract (field "name" [] themeSpec))
            )


themeSpec : ValueSpec NonNull EnumType Theme vars
themeSpec =
    enumWithDefault (always NoTheme)
        [ ( "Nature", Nature )
        , ( "Histoire", History )
        , ( "Culture", Culture )
        ]
