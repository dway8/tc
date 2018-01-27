module Update exposing (..)

import Model exposing (Model, Msg(..), Page(..), EditableData(..), Recording, Field(..), GraphQLData)
import Requests exposing (saveRecordingCmd)
import RemoteData exposing (RemoteData(..))
import Utils exposing (emitMsg)


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


setForm : EditableData Recording -> Model -> Model
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
        Editing r ->
            case field of
                Author ->
                    Editing { r | author = Just val }

                Description ->
                    Editing { r | description = Just val }

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
