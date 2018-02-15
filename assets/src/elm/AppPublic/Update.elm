module AppPublic.Update exposing (..)

import AppPublic.Model exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ReceiveQueryResponse response ->
            { model | recordings = response } ! []
