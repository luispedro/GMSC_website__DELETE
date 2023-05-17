module About exposing (..)
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
import Shared exposing (..)

main: Program () () Never
main =  
    Browser.document
    { init = \_ -> ((), Cmd.none)
    , update = \_ _ -> ((), Cmd.none)
    , subscriptions = \_ -> Sub.none
    , view = \_ ->
        { title = "GMSC:About"
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
                        , content
                        , Html.hr [] []
                        , Shared.footer
                        ]
                    ]
                ]
            ]
        }
    }


-- main text

content: Html msg
content = 
    span [id "introduction"]
        [Markdown.toHtml [] """
## The global microbial smORF catalogue (GMSC)
It is hosted by the [Big Data Biology Research Group](https://www.big-data-biology.org/).
___
**Version:** &emsp;&ensp; 1.0
___
**Contacts:** &emsp; [yiqian@big-data-biology.org](yiqian@big-data-biology.org) and [luispedro@big-data-biology.org](luispedro@big-data-biology.org)
___
**Affiliation:** &ensp; Institute of Science and Technology for Brain-Inspired Intelligence ([ISTBI](https://istbi.fudan.edu.cn/)). 23rd Floor, East Main Building of Guanghua Tower Fudan University 220 Handan Road, Yangpu District Shanghai (200433), China.
""" ]