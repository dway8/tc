port module AppPublic.Ports exposing (..)

import Json.Encode as E


type alias GenericOutsideData =
    { tag : String
    , data : E.Value
    }


type InfoForOutside
    = InitMap


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        InitMap ->
            infoForOutside { tag = "initMap", data = E.null }
