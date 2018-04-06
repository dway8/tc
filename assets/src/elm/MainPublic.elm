module MainPublic exposing (..)

import AppPublic.Model exposing (Model, Msg(..), initMap)
import AppPublic.Ports as Ports exposing (InfoForOutside(..))
import AppPublic.Requests exposing (fetchRecordingsCmd)
import AppPublic.Update exposing (update)
import AppPublic.View exposing (view)
import Html exposing (Html)
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
    , map = initMap
    , shownRecording = Nothing
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ fetchRecordingsCmd, Ports.sendInfoOutside InitMap ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Ports.getInfoFromOutside InfoFromOutside LogError ]
