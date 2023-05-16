module Home exposing (..)
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
                        , intro
                        , content_geo
                        , content_habitat
                        , content_taxonomy
                        , Html.hr [] []
                        , footer
                        ]
                    ]
                ]
            ]
        }
    }

-- main text


intro : Html msg
intro =
    span [id "introduction"]
        [Markdown.toHtml [] """
# Global Microbial smORFs Catalog v1.0

The global microbial smORF catalogue (GMSC) is an integrated, consistently-processed, smORFs catalog of the microbial world, combining publicly available metagenomes and high-quality isolated microbial genomes.
A total of non-redundant 9.6 billion 100AA ORFs were predicted from 63,410 metagenomes from global habitats and 87,920 high-quality isolated microbial genomes from the [ProGenomes](https://progenomes.embl.de/) database.
The smORFs were clustered at 90% amino acid identity resulting in 2.9 billion 90AA smORFs families.

- The annotation of GMSC contains: 
  - taxonomy classification
  - habitat assignment
  - quality assessment
  - conserved domain annotation
  - cellular localization prediction
""" ]


content_geo : Html msg
content_geo =
    span [id "content"]
        [Markdown.toHtml [] """
##### Geographical distribution
""" ]

content_habitat : Html msg
content_habitat =
    span [id "content"]
        [Markdown.toHtml [] """
##### Habitat distribution
""" ]

content_taxonomy : Html msg
content_taxonomy =
    span [id "content"]
        [Markdown.toHtml [] """
##### Taxonomy distribution
""" ]

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





{-
content: List (Html Never)
content = 
    [ div (Center.styles "800px")
        [ h1 [] [ text "GMSC" ]
        , a [] [ text """
                      The global microbial smORF catalogue (GMSC) is an integrated, consistently-processed, smORFs catalog of the microbial world, combining publicly available metagenomes and high-quality isolated microbial genomes.
                      A total of non-redundant 9.6 billion 100AA ORFs were predicted from 63,410 metagenomes from global habitats and 87,920 high-quality isolated microbial genomes from the ProGenomes2 database.                  
                      They were clustered at 90% amino acid identity resulting in 2.9 billion 90AA smORFs families.
                      """
               ]
        , p [ style "margin-top" "1em" ] 
            [ text "The annotation of GMSC contains: taxonomy classification, habitat assignment, quality assessment, conserved domain annotation, and cellular localization prediction."]
        , h1 [style "margin-top" "1em"] [ text "A figure to show geo distribution" ]
        , h1 [style "margin-top" "1em"] [ text "A figure to show habitat distribution" ]
        , h1 [style "margin-top" "1em"] [ text "A figure to show taxonomy distribution" ]       
        ]
    ]
-}



{-
        , p [ style "margin-top" "3em" ]
            [ span [ style "font-weight" "bold" ] [ text "Reminder:" ]
            , text " Read through "
            , a [ href "https://guide.elm-lang.org" ] [ text "The Official Guide" ]
            , text " to learn the basics of Elm. It will help a lot with understanding these examples!"
            ]
-- VIEW EXAMPLES


viewExamples : String -> List String -> Html msg
viewExamples sectionTitle examples =
  div
    [ style "width" "200px"
    ]
    [ h2 [ style "margin-bottom" "0" ] [ text sectionTitle ]
    , ul
        [ style "list-style-type" "none"
        , style "padding-left" "16px"
        , style "margin-top" "8px"
        ]
        (List.map viewExample examples)
    ]


viewExample : String -> Html msg
viewExample example =
  let
    url = "/examples/" ++ String.replace " " "-" (String.toLower example)
  in
  li [] [ a [ href url ] [ text example ] ]
-}