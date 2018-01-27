module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, Msg, Page(..), EditableData(..))
import Update exposing (update)
import View exposing (view)
import Requests exposing (fetchRecordingsCmd)
import RemoteData exposing (RemoteData(..))


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initialModel : Model
initialModel =
    { recordings = NotAsked
    , page = ListPage
    , form = NotEditing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchRecordingsCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
