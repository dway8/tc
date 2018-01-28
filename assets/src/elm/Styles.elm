module Styles exposing (..)

import Style exposing (..)
import Style.Font as Font
import Style.Scale as Scale
import Style.Border as Border
import Element exposing (Element)
import Style.Color as SC
import Color as Color


type Styles
    = None
    | Main
    | Hairline
    | Button
    | Input


type Variations
    = Larger
    | Smaller
    | Smallest
    | Bold
    | Primary
    | Grey
    | Danger
    | Info


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
            , SC.border Color.grey
            ]
        , style Button
            [ variation Primary [ SC.background green, SC.text Color.white, hover [ SC.background darkGreen ] ]
            , variation Grey [ SC.background grey, SC.text Color.white, hover [ SC.background darkGrey ] ]
            , variation Danger [ SC.background red, SC.text Color.white, hover [ SC.background darkRed ] ]
            , variation Info [ SC.background info, SC.text Color.white, hover [ SC.background darkInfo ] ]
            ]
        , style Input
            [ Border.rounded 4
            , Border.all 1
            , Border.solid
            , SC.border Color.grey
            ]
        ]


darkInfo : Color.Color
darkInfo =
    Color.rgb 0 153 204


info : Color.Color
info =
    Color.rgb 51 181 229


darkGreen : Color.Color
darkGreen =
    Color.rgb 0 126 51


green : Color.Color
green =
    Color.rgb 0 200 81


darkGrey : Color.Color
darkGrey =
    Color.rgb 158 158 158


grey : Color.Color
grey =
    Color.rgb 189 189 189


darkRed : Color.Color
darkRed =
    Color.rgb 204 0 0


red : Color.Color
red =
    Color.rgb 255 68 68


scaled : Int -> Float
scaled =
    Scale.modular 12 1.618


type alias Elem msg =
    Element Styles Variations msg
