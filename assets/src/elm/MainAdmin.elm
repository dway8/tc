module MainAdmin exposing (..)

import Html exposing (Html)
import AppAdmin.Model exposing (Model, Msg(..), Page(..), EditableData(..))
import AppAdmin.Update exposing (update)
import AppAdmin.View exposing (view)
import AppAdmin.Requests exposing (fetchRecordingsCmd)
import RemoteData exposing (RemoteData(..))
import AppAdmin.Ports as Ports


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
    Sub.batch [ Ports.getInfoFromOutside InfoFromOutside LogError ]
