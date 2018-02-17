module AppPublic.Update exposing (..)

import AppPublic.Model exposing (Model, Msg(..))
import AppPublic.Ports as Ports exposing (InfoForOutside(..))
import RemoteData exposing (RemoteData(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ReceiveQueryResponse response ->
            let
                cmd =
                    case response of
                        Success recordings ->
                            Ports.sendInfoOutside <| DisplayMarkers recordings

                        _ ->
                            Cmd.none
            in
                { model | recordings = response } ! [ cmd ]
