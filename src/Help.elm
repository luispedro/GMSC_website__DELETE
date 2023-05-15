module Help exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Center
import Dict

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row

import Center
import Skeleton


main: Program () () Never
main =  
    Browser.document
    { init = \_ -> ((), Cmd.none)
    , update = \_ _ -> ((), Cmd.none)
    , subscriptions = \_ -> Sub.none
    , view = \_ ->
        { title = "GMSC:Help"
        , body = [ Skeleton.header, div [] content, Skeleton.footer ]
        }
    }

content: List (Html Never)
content = 
    [ div (Center.styles "800px")
        [ h1 [] [ text "Overview" ]
        , a [style "margin-top" "1em"] [ text "description" ]
        , h1 [style "margin-top" "1em"] [ text "Benefits and Features" ]     
        , a [style "margin-top" "1em"] [ text "description" ]
        , h1 [style "margin-top" "1em"] [ text "Searching" ]
        , h2 [style "margin-top" "1em"] [ text "GMSC-mapper" ]
        , h1 [style "margin-top" "1em"] [ text "Identifiers" ]
        , h1 [style "margin-top" "1em"] [ text "Data acquistion" ]   
        , a [style "margin-top" "1em"] [ text "description" ]
        , h1 [style "margin-top" "1em"] [ text "Method" ]
        , a [style "margin-top" "1em"] [ text "A figure overview" ] 
        , h2 [style "margin-top" "1em"] [ text "Read processing and assembly" ]
        , h2 [style "margin-top" "1em"] [ text "Identification of smORFs" ]
        , h2 [style "margin-top" "1em"] [ text "Protein family generation" ]
        , h2 [style "margin-top" "1em"] [ text "Taxonomy & Habitat annotation" ]
        , h2 [style "margin-top" "1em"] [ text "Conserved domain annotation" ]
        , h2 [style "margin-top" "1em"] [ text "Cellular localization prediction" ]
        , h2 [style "margin-top" "1em"] [ text "Quality estimation" ]
        , h1 [style "margin-top" "1em"] [ text "Reference" ]
        , h1 [style "margin-top" "1em"] [ text "API" ]
        ]
    ]