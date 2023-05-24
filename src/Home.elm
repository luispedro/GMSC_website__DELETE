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
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea

import Shared exposing (..)


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
                        [ Shared.header
                        , intro
                        , search
                        , content_geo
                        , content_habitat
                        , content_taxonomy
                        , Html.hr [] []
                        , Shared.footer
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
A total of non-redundant 965 million 100AA ORFs were predicted from 63,410 metagenomes from global habitats and 87,920 high-quality isolated microbial genomes from the [ProGenomes](https://progenomes.embl.de/) database.
The smORFs were clustered at 90% amino acid identity resulting in 288 million 90AA smORFs families.

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
![Geographical distribution](assets/home_geo.svg)
""" ]

content_habitat : Html msg
content_habitat =
    span [id "content"]
        [Markdown.toHtml [] """
##### Habitat distribution
""" ]

content_taxonomy : Html msg
content_taxonomy =
    span [id "home"]
        [Markdown.toHtml [] """
##### Taxonomy distribution
![Taxonomy distribution](assets/home_taxonomy.svg)
""" ]

search : Html msg
search = 
  div [class "search"]
    [ Form.form []
        [ Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ h4 [] [ text "Find homologues by sequence (GMSC-mapper) or search by identifier"]
                ]
            ]       
        , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ Form.group []
                    [ Form.label [] [ text "Identifier" ]
                    , Input.text [ Input.attrs [ placeholder "GMSC10.100AA_000_000_000   or   GMSC10.90AA_000_000_000" ] ]
                    , Button.button[ Button.info,Button.attrs [ class "float-right"]] [ text "Submit" ]
                    ]            
                ]
            ]
        , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ ButtonGroup.buttonGroup [ ButtonGroup.small ]
                    [ ButtonGroup.button [ Button.outlineInfo ] [ text "Search from contigs" ]
                    , ButtonGroup.button [ Button.outlineInfo,Button.attrs [ class "ml-3" ]] [ text "Search from proteins" ]
                    ]
                ]
            ]
       , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ Form.group []
                    [ label [ for "myarea"] [ text "Input an amino acid / nucleotide sequence in FASTA format"]
                    , Textarea.textarea
                        [ Textarea.id "myarea"
                        , Textarea.rows 3
                        , Textarea.attrs [ placeholder ">contigID\n AATACTACATGTCA..." ]
                        ]
                    , Button.button[ Button.info,Button.attrs [ class "float-right"]] [ text "Submit" ]
                    ]
                ]
            ]            
        ]
    ]