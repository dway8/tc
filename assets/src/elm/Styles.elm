module Styles exposing (..)

import Style exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Element exposing (Element)


type Styles
    = None
    | Main


type Variations
    = Larger
    | Smaller
    | Smallest


stylesheet : StyleSheet Styles Variations
stylesheet =
    styleSheet
        [ style None
            [ variation Larger [ Font.size (scaled 4) ]
            , variation Smaller [ Font.size (scaled 2) ]
            , variation Smallest [ Font.size (scaled 1) ]
            ]
        , style Main
            [ Font.size (scaled 3)
            , Font.typeface [ Font.font "Roboto" ]
            , Font.weight 400
            ]
        ]


scaled : Int -> Float
scaled =
    Scale.modular 12 1.618


type alias Elem msg =
    Element Styles Variations msg
