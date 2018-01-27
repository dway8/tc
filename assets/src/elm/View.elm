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
        el Main [] <|
            case model.page of
                ListPage ->
                    column None
                        [ spacing 20 ]
                        [ el None [ vary Bold True ] <| text "List"
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
            [ el None [] <| column None [] [ text (Maybe.withDefault "" r.author), text (Maybe.withDefault "" r.description) ]
            , el None [] <| button None [ onClick <| EditRecording r ] <| text "Editer"
            ]


editRecording : Recording -> Elem Msg
editRecording r =
    el None [] <|
        column None
            []
            [ viewTextInput Author r.author "Auteur"
            , viewTextInput Description r.description "Description"
            , button None [ onClick SaveRecording ] <| text "Enregistrer"
            , button None [ onClick CancelEditing ] <| text "Annuler"
            ]


viewTextInput : Field -> Maybe String -> String -> Elem Msg
viewTextInput field val label =
    Input.text None
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
