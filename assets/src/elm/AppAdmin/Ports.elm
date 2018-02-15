port module AppAdmin.Ports exposing (..)

import Json.Decode as D
import Json.Encode as E
import Json.Decode.Pipeline as P
import Utils exposing (Coordinates)


type alias GenericOutsideData =
    { tag : String
    , data : E.Value
    }


type InfoForOutside
    = InitSearch String


type InfoForElm
    = PlaceSelected PlaceSelectedData


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        InitSearch string ->
            infoForOutside { tag = "initSearch", data = E.string string }


getInfoFromOutside : (InfoForElm -> msg) -> (String -> msg) -> Sub msg
getInfoFromOutside tagger onError =
    infoForElm
        (\outsideInfo ->
            case outsideInfo.tag of
                "placeSelected" ->
                    case D.decodeValue placeSelectedDecoder outsideInfo.data of
                        Ok data ->
                            tagger <| PlaceSelected data

                        Err err ->
                            onError err

                otherwise ->
                    onError "Unknown message type"
        )


type alias PlaceSelectedData =
    { searchAddress : String
    , address : String
    , city : String
    , coordinates : Coordinates
    }


placeSelectedDecoder : D.Decoder PlaceSelectedData
placeSelectedDecoder =
    P.decode PlaceSelectedData
        |> P.required "searchAddress" D.string
        |> P.required "address" D.string
        |> P.required "city" D.string
        |> P.required "coordinates" coordinatesDecoder


coordinatesDecoder : D.Decoder Coordinates
coordinatesDecoder =
    P.decode Coordinates
        |> P.required "lat" D.float
        |> P.required "lng" D.float
