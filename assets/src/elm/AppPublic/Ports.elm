port module AppPublic.Ports exposing (..)

import Json.Encode as E
import Recording exposing (Recording)
import Utils exposing (Coordinates)


type alias GenericOutsideData =
    { tag : String
    , data : E.Value
    }


type InfoForOutside
    = InitMap
    | DisplayMarkers (List Recording)


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        InitMap ->
            infoForOutside { tag = "initMap", data = E.null }

        DisplayMarkers recordings ->
            infoForOutside
                { tag = "displayMarkers"
                , data = E.list <| List.map encodeMarker recordings
                }


encodeMarker : Recording -> E.Value
encodeMarker rec =
    E.object
        [ ( "id", E.string rec.id )
        , ( "coordinates", encodeCoordinates rec.coordinates )
        ]


encodeCoordinates : Coordinates -> E.Value
encodeCoordinates coordinates =
    E.object
        [ ( "lat", E.float coordinates.lat )
        , ( "lng", E.float coordinates.lng )
        ]
