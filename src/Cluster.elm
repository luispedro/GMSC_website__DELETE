module Cluster exposing (..)
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
        { title = "GMSC:smORF"
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
                        , identifier
                        , content
                        , Html.hr [] []
                        , members
                        , Html.hr [] []
                        , Shared.footer
                        ]
                    ]
                ]
            ]
        }
    }

-- main text


identifier : Html msg
identifier =
    span [id "sequence"]
        [Markdown.toHtml [] """
# GMSC10.90AA.000_000_001
""" ]

content : Html msg
content = table [] [ tr [] [ td [id "info"] [text "Consensus sequence"]
                           , td [] [text "MAAAAAAAAAAAAAAAAAAAAAAAAVAVAVAAAATAA"]
                           ]
                    , tr [id "alt"] [ td [id "info"] [text "Taxonomic assignment"]
                            , td [] [text "-"]
                            ]
                    , tr [] [ td [id "info"] [text "Habitat"]
                            , td [] [text "lake associated"]
                            ]
                    , tr [id "alt"] [ td [id "info"] [text "Conserved domain"]
                            , td [] [text "-"]
                            ]
                    , tr [] [ td [id "info"] [text "Cellular localization"]
                            , td [] [text "Transmembrane or secreted"]
                            ]
                    , tr [id "alt"] [ td [id "info"] [text "Number of 100AA smORFs:"]
                            , td [] [text "1"]
                            ]                    
                    ]

members : Html msg
members = div [] [h4 [id "cluster"] [ text  "This 90AA cluster contains the following 100AA smORFs:"]
                 , p [] [text "a table to be done"]
                 ]
