module AppPublic.View exposing (..)

import AppPublic.Model exposing (Model, Msg(..))
import Html exposing (Html)
import Html.Attributes as HA
import Html.Keyed
import Element exposing (..)
import Styles exposing (Styles(..), Variations(..), stylesheet, Elem)
import Element.Attributes exposing (..)


view : Model -> Html Msg
view model =
    layout stylesheet <|
        el Main [ width fill ] <|
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
