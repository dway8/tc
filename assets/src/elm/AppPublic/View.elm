module AppPublic.View exposing (..)

import AppPublic.Model exposing (Model, Msg(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Keyed
import Recording exposing (Recording, getAuthor, getDescription)
import Styles exposing (Elem, Styles(..), Variations(..), stylesheet)


view : Model -> Html Msg
view model =
    layout stylesheet <|
        el Main [ width fill ] <|
            within [ viewShownRecording model.shownRecording ] <|
                el None [ width fill, height <| px 900 ] <|
                    html <|
                        Html.Keyed.node "div"
                            [ HA.style
                                [ ( "width", "100%" )
                                , ( "height", "100%" )
                                , ( "position", "relative" )
                                ]
                            ]
                            [ ( "gmaps", mapHtml ) ]


mapHtml : Html Msg
mapHtml =
    Html.div [ HA.id "gmaps", HA.style [ ( "height", "100%" ), ( "width", "100%" ) ] ] []


viewShownRecording : Maybe Recording -> Elem Msg
viewShownRecording recording =
    case recording of
        Nothing ->
            empty

        Just rec ->
            within
                [ el None
                    [ width fill
                    , height fill
                    , onClick CloseRecordingDialog

                    -- , vary Clickable True
                    ]
                  <|
                    empty
                , el Modal
                    [ center
                    , height <| px 300
                    , width <| px 880
                    ]
                  <|
                    el None [] <|
                        column None
                            []
                            [ text rec.id
                            , text <| getAuthor rec
                            , text <| getDescription rec
                            ]
                ]
            <|
                el None
                    [ height fill
                    , width fill
                    ]
                    empty
