module View exposing (..)

import Model exposing (Model, Msg(..), Recording, GraphQLData, Page(..), Field(..))
import Html exposing (Html)
import Element exposing (..)
import Styles exposing (Styles(..), Variations(..), stylesheet, Elem)
import RemoteData exposing (RemoteData(..))
import Element.Events exposing (onClick)
import Element.Attributes exposing (..)
import Element.Input as Input


view : Model -> Html Msg
view model =
    viewport stylesheet <|
        el Main [ padding 20, width <| percent 60, maxWidth <| px 900 ] <|
            case model.page of
                ListPage ->
                    column None
                        [ spacing 20 ]
                        [ el None [ vary Bold True ] <| text "List"
                        , button Button [ vary Info True, onClick OpenCreateView, padding 10 ] <| text "Ajouter nouveau"
                        , viewRecordings model.recordings
                        ]

                EditPage r ->
                    editRecording r


viewRecordings : GraphQLData (List Recording) -> Elem Msg
viewRecordings recordings =
    case recordings of
        Success r ->
            r
                |> List.map viewRecording
                |> List.intersperse (hairline Hairline)
                |> column None [ spacing 5 ]
                |> el None []

        _ ->
            empty


viewRecording : Recording -> Elem Msg
viewRecording r =
    el None [] <|
        row None
            []
            [ el None [ width <| fillPortion 4 ] <| column None [] [ text (Maybe.withDefault "" r.author), text (Maybe.withDefault "" r.description) ]
            , el None [ width <| fillPortion 1 ] <|
                row None
                    [ spacing 10, alignRight ]
                    [ button Button [ vary Primary True, onClick <| EditRecording r, padding 10 ] <| text "Editer"
                    , button Button [ vary Danger True, onClick <| DeleteRecording r.id, padding 10 ] <| text "Supprimer"
                    ]
            ]


editRecording : Recording -> Elem Msg
editRecording r =
    el None [] <|
        column None
            [ spacing 20 ]
            [ viewTextInput Author r.author "Auteur"
            , viewTextInput Description r.description "Description"
            , el None [] <|
                row None
                    [ spacing 10 ]
                    [ button Button [ vary Grey True, onClick CancelEditing, padding 10 ] <| text "Annuler"
                    , button Button [ vary Primary True, onClick SaveRecording, padding 10 ] <| text "Enregistrer"
                    ]
            ]


viewTextInput : Field -> Maybe String -> String -> Elem Msg
viewTextInput field val label =
    Input.text Input
        [ padding 8
        , width fill
        ]
        { onChange = UpdateRecordingField field
        , value = Maybe.withDefault "" val
        , options = []
        , label =
            Input.labelAbove <|
                el None [ vary Bold True ] <|
                    row None
                        [ spacing 8, verticalCenter ]
                        [ text label
                        ]
        }
