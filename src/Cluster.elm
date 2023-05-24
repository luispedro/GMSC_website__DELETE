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
                        , title
                        , members
                        , page_select
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
                    , tr [] [ td [id "info"] [text "Quality"]
                            , td [] [text "High quality"]
                            ]             
                    ]

title : Html msg
title = div [] [h4 [id "cluster"] [ text  "This 90AA cluster contains the following 100AA smORFs:"]]

members : Html msg
members = table [id "member"] [  tr [] [ th [] [text "100AA smORF accession"]
                            , th [] [text "Protein sequence"]
                            , th [] [text "Taxonomy"]
                            , th [] [text "Habitat"]
                            , th [] [text "Quality"]
                            ]
                    , tr [] [ td [id "member"] [a [ href "https://guide.elm-lang.org" ] [text "GMSC10.100AA.000_000_001"]]
                            , td [id "member"] [text "MAAAAAAAAAAAAAAAAAAAAAAAAVAVAVAAAATAA"]
                            , td [id "member"] [text "-"]
                            , td [id "member"] [text "lake associated"]
                            , td [id "member"] [text "High quality"]
                            ]
                   ]

page_select : Html msg
page_select = div [class "dropdown"]
                  [ p [class "number"] [ text "Total 1"]
                  , button [class "dropbtn"] [text "5/Page"]
                  , div [class "dropdown-content"] 
                        [ p [] [text "10/Page"]
                        , p [] [text "15/Page"]
                        , p [] [text "20/Page"]]
                  , ul [class "pagination"] 
                       [ li [] [a [href "#"] [text "«"]]
                       , li [] [a [href "#"] [text "1"]]
                       , li [] [a [href "#"] [text "2"]]
                       , li [] [a [href "#"] [text "3"]]
                       , li [] [a [href "#"] [text "4"]]
                       , li [] [a [href "#"] [text "5"]]
                       , li [] [a [href "#"] [text "»"]]
                       ]
                  ]