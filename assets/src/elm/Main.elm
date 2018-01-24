module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, Msg)
import Update exposing (update)
import View exposing (view)
import Requests exposing (sendRecordingsQuery)
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
    { recordings = NotAsked }


init : ( Model, Cmd Msg )
init =
    ( initialModel, sendRecordingsQuery )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
