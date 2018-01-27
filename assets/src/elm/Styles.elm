module Styles exposing (..)

import Style exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Style.Border as Border
import Element exposing (Element)
import Style.Color as Color
import Color exposing (grey)


type Styles
    = None
    | Main
    | Hairline


type Variations
    = Larger
    | Smaller
    | Smallest
    | Bold


stylesheet : StyleSheet Styles Variations
stylesheet =
    styleSheet
        [ style None
            [ variation Larger [ Font.size (scaled 4) ]
            , variation Smaller [ Font.size (scaled 2) ]
            , variation Smallest [ Font.size (scaled 1) ]
            , variation Bold [ Font.weight 700 ]
            ]
        , style Main
            [ Font.size 15
            , Font.typeface [ Font.font "Roboto" ]
            , Font.weight 400
            ]
        , style Hairline
            [ Border.top 1
            , Border.solid
            , Color.border grey
            ]
        ]


scaled : Int -> Float
scaled =
    Scale.modular 12 1.618


type alias Elem msg =
    Element Styles Variations msg
