module View exposing (..)

import Model exposing (Model, Msg, Recording, GraphQLData)
import Html exposing (Html)
import Element exposing (..)
import Styles exposing (Styles(..), stylesheet, Elem)
import RemoteData exposing (RemoteData(..))


view : Model -> Html Msg
view model =
    viewport stylesheet <|
        el Main [] <|
            column None
                []
                [ text "list"
                , viewRecordings model.recordings
                ]


viewRecordings : GraphQLData (List Recording) -> Elem Msg
viewRecordings recordings =
    case recordings of
        Success r ->
            r
                |> List.map viewRecording
                |> column None []
                |> el None []

        _ ->
            empty


viewRecording : Recording -> Elem Msg
viewRecording recording =
    el None [] <| column None [] [ text recording.author, text recording.description ]
