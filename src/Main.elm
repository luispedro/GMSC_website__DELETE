module Main exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)

main : Html msg
main =
  svg
    [ viewBox "0 0 400 400"
    , width "400"
    , height "400"
    ]
    [ rect
        [ x "0"
        , y "0"
        , width "400"
        , height "40"
        , fill "#f0f8ff"
        ]
        []

    ]