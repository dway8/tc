module AppPublic.View exposing (..)

import AppPublic.Model exposing (Model, Msg(..))
import Html exposing (Html)
import Element exposing (..)
import Styles exposing (Styles(..), Variations(..), stylesheet, Elem)
import RemoteData exposing (RemoteData(..))
import Element.Events exposing (onClick)
import Element.Attributes exposing (..)


view : Model -> Html Msg
view model =
    viewport stylesheet <|
        el Main [] <|
            text ""
