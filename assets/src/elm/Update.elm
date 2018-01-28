module Update exposing (..)

import Model exposing (Model, Msg(..), Page(..), EditableData(..), Recording, Field(..), GraphQLData, RecordingId, newRecording)
import Requests exposing (saveRecordingCmd, deleteRecordingCmd)
import RemoteData exposing (RemoteData(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ReceiveQueryResponse response ->
            { model | recordings = response } ! []

        EditRecording r ->
            { model | page = EditPage r, form = Editing r } ! []

        UpdateRecordingField field val ->
            (model
                |> setForm (updateForm field val model.form)
            )
                ! []

        SaveRecording ->
            model ! [ saveRecordingCmd model.form ]

        CancelEditing ->
            { model | page = ListPage, form = NotEditing } ! []

        SaveRecordingResponse response ->
            case response of
                Success r ->
                    (model
                        |> setRecordings (updateRecordings r model.recordings)
                        |> setPage ListPage
                    )
                        ! []

                _ ->
                    model ! []

        DeleteRecording id ->
            model ! [ deleteRecordingCmd id ]

        DeleteRecordingResponse response ->
            case response of
                Success id ->
                    (model
                        |> setRecordings (deleteFromRecordings id model.recordings)
                    )
                        ! []

                _ ->
                    model ! []

        OpenCreateView ->
            (model
                |> setForm (Editing newRecording)
                |> setPage (EditPage newRecording)
            )
                ! []


deleteFromRecordings : RecordingId -> GraphQLData (List Recording) -> GraphQLData (List Recording)
deleteFromRecordings id =
    RemoteData.map
        (\list ->
            List.filter (\r -> r.id /= id) list
        )


setForm : EditableData RecordingForm -> Model -> Model
setForm form model =
    { model | form = form }


setRecordings : GraphQLData (List Recording) -> Model -> Model
setRecordings recordings model =
    { model | recordings = recordings }


setPage : Page -> Model -> Model
setPage page model =
    { model | page = page }


updateForm : Field -> String -> EditableData Recording -> EditableData Recording
updateForm field val form =
    case form of
        Editing f ->
            let
                oldRec =
                    f.recording

                newRec =
                    case field of
                        Author ->
                            { oldRec | author = Just val }

                        Description ->
                            { oldRec | description = Just val }
            in
                Editing { f | recording = newRec }

        _ ->
            form


updateRecordings : Recording -> RemoteData e (List Recording) -> RemoteData e (List Recording)
updateRecordings updatedRec =
    RemoteData.map
        (\list ->
            case list |> List.filter (.id >> (==) updatedRec.id) |> List.head of
                Nothing ->
                    updatedRec :: list

                Just _ ->
                    list
                        |> List.map
                            (\r ->
                                if r.id == updatedRec.id then
                                    updatedRec
                                else
                                    r
                            )
        )
