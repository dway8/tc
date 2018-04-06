module AppPublic.Update exposing (..)

import AppPublic.Model exposing (Model, Msg(..))
import AppPublic.Ports as Ports exposing (InfoForElm(..), InfoForOutside(..))
import Recording exposing (Recording)
import RemoteData exposing (RemoteData(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ReceiveQueryResponse response ->
            let
                cmd =
                    case response of
                        Success recordings ->
                            Ports.sendInfoOutside <| DisplayMarkers recordings

                        _ ->
                            Cmd.none
            in
            { model | recordings = response } ! [ cmd ]

        InfoFromOutside infoForElm ->
            case infoForElm of
                MarkerClicked id ->
                    let
                        currentId =
                            model.shownRecording
                                |> Maybe.map .id
                                |> Maybe.withDefault "0"

                        newShownRecording =
                            if currentId == id then
                                Nothing
                            else
                                findRecordingById model id
                    in
                    { model | shownRecording = newShownRecording } ! []

        LogError error ->
            let
                debug =
                    Debug.log "error:" error
            in
            model ! []

        CloseRecordingDialog ->
            { model | shownRecording = Nothing } ! []


findRecordingById : Model -> String -> Maybe Recording
findRecordingById model id =
    model.recordings
        |> RemoteData.toMaybe
        |> Maybe.map (List.filter (.id >> (==) id))
        |> Maybe.map List.head
        |> Maybe.withDefault Nothing
