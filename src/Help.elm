module Help exposing (..)
import Html exposing (..)
import Html.Attributes as HtmlAttr
import Html.Attributes exposing (..)
import Browser
import Dict
import Markdown
import View exposing (View)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row

import Center

main: Program () () Never
main =
    Browser.document
    { init = \_ -> ((), Cmd.none)
    , update = \_ _ -> ((), Cmd.none)
    , subscriptions = \_ -> Sub.none
    , view = \_ ->
        { title = "GMSC:Home"
        , body =
            [ CDN.stylesheet
            , CDN.fontAwesome
            , Html.node "link"
                [ HtmlAttr.rel "stylesheet"
                , HtmlAttr.href "style.css"
                ]
                []
            , Grid.containerFluid []
                [ Grid.simpleRow
                    [ Grid.col []
                        [ header
                        , content
                        , Html.hr [] []
                        , footer
                        ]
                    ]
                ]
            ]
        }
    }

content : Html msg
content =
    span [id "help"]
        [Markdown.toHtml [] """
## Overview
Description
## Benefits and Features
Description
## Searching
Description
## Identifiers
smORFs in the catalog are identified with the scheme `GMSC10.100AA.XXX_XXX_XXX` or `GMSC10.90AA.XXX_XXX_XXX`. The initial `GMSC10` indicates the version of the catalog (Global Microbial smORFs Catalog 1.0). The `100AA` or `90AA` indicates the amino acid identity of the catalog. The `XXX_XXX_XXX` is a unique numerical identifier (starting at zero). Numbers were assigned in order of increasing number of copies. So that the greater the number, the greater number of copies of that peptide were present in the raw data. 
## Data acquistion
Description
## Method
A figure overview
#### Read processing and assembly
Description
#### Identification of smORFs
Description
#### Protein family generation
Description
#### Taxonomy & Habitat annotation
Description
#### Conserved domain annotation
Description
#### Cellular localization prediction
Description
#### Quality assessment
Description
## Refrence
Description
""" ]
{-
content: Html msg
content = 
    div (Center.styles "800px")
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
        , h1 [style "margin-top" "1em"] [ text "c" ]
        , h1 [style "margin-top" "1em"] [ text "API" ]
        ]
-}
-- header


header : Html msg
header =
    let
        link target name =
            Grid.col []
                     [Html.a [href target] [Html.text name]
                     ]
    in div
        [id "topbar"]
        [Grid.simpleRow
            [ link "/home/" "Home"
            , link "/browse_data/" "Browse"
            , link "/downloads/" "Downloads"
            , link "/help/" "Help"
            , link "/about/" "About&Contact"
            ]
        ]

-- FOOTER


footer : Html msg
footer =
  div [id "footerbar"]
      [ a [][ text "Copyright (c) 2023 GMSC authors. All rights reserved."]
      ]