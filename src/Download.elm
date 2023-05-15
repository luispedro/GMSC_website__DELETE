module Download exposing (..)
import Html exposing (..)
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
        { title = "GMSC:Downloads"
        , body = 
            [ CDN.stylesheet
            , CDN.fontAwesome
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

content: Html msg
content = 
    div []
        [ h1 [] [ text "Data Downloads" ]
        , a [] [ text "We provide a 100% non-redundant catalog (including 964,970,496 smORFs) and a 90% amino-acid level catalog (287,926,875 smORFs families). "]
        , h2 [style "margin-top" "1em"] [ text "Protein sequence(.fasta)" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.faa.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.faa.xz" ]
        , h2 [style "margin-top" "1em"] [ text "Nucleotide sequence(.fasta)" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.fna.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.fna.xz" ]
        , h2 [style "margin-top" "1em"] [ text "Protein clustering table" ]
        , a [] [ text "description"]
        , p [ style "margin-top" "1em" ] [a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.cluster.tsv.xz" ]]
        , h2 [style "margin-top" "1em"] [ text "Taxonomy annotation" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.taxonomy.tsv.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.taxonomy.tsv.xz" ]       
        , h2 [style "margin-top" "1em"] [ text "Habitat annotation" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.habitat.tsv.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.habitat.tsv.xz" ]   
        , h2 [style "margin-top" "1em"] [ text "Quality assessment" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.quality.tsv.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.quality.tsv.xz" ]  
        , h2 [style "margin-top" "1em"] [ text "Conserved domain annotation" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.cdd.tsv.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.cdd.tsv.xz" ]    
        , h2 [style "margin-top" "1em"] [ text "cellular localization prediction" ]
        , a [] [ text "description"]
        , h3 [style "margin-top" "1em"] [ text "100AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.100AA.transmemrane-secreted.tsv.xz" ]
        , h3 [style "margin-top" "1em"] [ text "90AA catalog" ]
        , a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.90AA.transmemrane-secreted.tsv.xz" ]  
        , h2 [style "margin-top" "1em"] [ text "Metadata" ]
        , a [] [ text "description"]
        , p [ style "margin-top" "1em" ] [a [ href "https://gmgc.embl.de/download.cgi" ] [ text "GMSC10.metadata.tsv.xz" ]]      
        ]

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