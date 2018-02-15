module MainPublic exposing (..)

import Html exposing (Html)
import AppPublic.Model exposing (Model, Msg(..))
import AppPublic.Update exposing (update)
import AppPublic.View exposing (view)
import AppPublic.Requests exposing (fetchRecordingsCmd)
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
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchRecordingsCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []
