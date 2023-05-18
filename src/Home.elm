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