module Update exposing (..)

import Model exposing (Model, Msg(..), Page(..), EditableData(..), Recording, Field(..), GraphQLData, RecordingId, newRecording, RecordingForm, Theme(..), addressInputId)
import Requests exposing (saveRecordingCmd, deleteRecordingCmd)
import RemoteData exposing (RemoteData(..))
import Element.Input as Input
import Ports exposing (InfoForOutside(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ReceiveQueryResponse response ->
            { model | recordings = response } ! []

        EditRecording r ->
            { model | page = EditPage r, form = initFormWithRecording r } ! [ Ports.sendInfoOutside <| InitSearch addressInputId ]

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
                |> setForm (Editing <| RecordingForm newRecording (Input.dropMenu (Just NoTheme) SelectTheme))
                |> setPage (EditPage newRecording)
            )
                ! []

        SelectTheme selectMsg ->
            (model
                |> setForm (updateTheme model.form selectMsg)
            )
                ! []


updateTheme : EditableData RecordingForm -> Input.SelectMsg Theme -> EditableData RecordingForm
updateTheme form selectMsg =
    case form of
        Editing f ->
            f
                |> (\f -> { f | theme = Input.updateSelection selectMsg f.theme })
                |> (\f -> { f | recording = setRecordingTheme f.theme f.recording })
                |> Editing

        _ ->
            form


setRecordingTheme : Input.SelectWith Theme Msg -> Recording -> Recording
setRecordingTheme theme recording =
    { recording | theme = Input.selected theme |> Maybe.withDefault NoTheme }


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


initFormWithRecording : Recording -> EditableData RecordingForm
initFormWithRecording rec =
    Editing <| RecordingForm rec (Input.dropMenu (Just rec.theme) SelectTheme)


updateForm : Field -> String -> EditableData RecordingForm -> EditableData RecordingForm
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

                        SearchAddress ->
                            { oldRec | searchAddress = Just val }
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
