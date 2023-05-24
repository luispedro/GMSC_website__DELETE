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
import Bootstrap.Table as Table
import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
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
content = Table.table
    { options = [ Table.striped, Table.small,Table.hover]
    , thead =  Table.simpleThead []
    , tbody =
        Table.tbody []
            [ Table.tr []
                [ Table.td [] [p [id "title"] [text "Consensus sequence"]  ]
                , Table.td [] [p [id "detail"] [text "MAAAAAAAAAAAAAAAAAAAAAAAAVAVAVAAAATAA"] ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Taxonomic assignment"] ]
                , Table.td [] [ p [id "detail"] [text "-"] ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Habitat"]  ]
                , Table.td [] [ p [id "detail"] [text "lake associated"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Conserved domain"]  ]
                , Table.td [] [ p [id "detail"] [text "-"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Cellular localization"]  ]
                , Table.td [] [ p [id "detail"] [text "Transmembrane or secreted"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Number of 100AA smORFs:"]  ]
                , Table.td [] [ p [id "detail"] [text "1"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Quality"]  ]
                , Table.td [] [ p [id "detail"] [text "High quality"]  ]
                ]
            ]
    }

title : Html msg
title = div [id "cluster"] [ h4 [id "cluster"] [ text  "This 90AA cluster contains the following 100AA smORFs:"]
            ,Button.button [ Button.info,Button.attrs [] ] [ text "Download .csv" ]
               ]

members : Html msg
members = Table.table
    { options = [ Table.hover ]
    , thead =  Table.simpleThead
        [ Table.th [] [ text "100AA smORF accession" ]
        , Table.th [] [ text "Protein sequence" ]
        , Table.th [] [ text "Taxonomy" ]
        , Table.th [] [ text "Habitat" ]
        , Table.th [] [ text "Quality" ]
        ]
    , tbody =
        Table.tbody []
            [ Table.tr []
                [ Table.td [] [a [ href "https://guide.elm-lang.org" ] [text "GMSC10.100AA.000_000_001"]]
                , Table.td [] [ text "MAAAAAAAAAAAAAAAAAAAAAAAAVAVAVAAAATAA" ]
                , Table.td [] [ text "-" ]
                , Table.td [] [ text "lake associated" ]
                , Table.td [] [ text "High quality" ]
                ]
            , Table.tr []
                [ Table.td [] [a [ href "https://guide.elm-lang.org" ] [text "GMSC10.100AA.000_000_002"]]
                , Table.td [] [ text "MAAAAAAAAAAAAAAVAVAVAAAATAA" ]
                , Table.td [] [ text "f__Streptosporangiaceae" ]
                , Table.td [] [ text "lake associated" ]
                , Table.td [] [ text "High quality" ]
                ]
            , Table.tr []
                [ Table.td [] [a [ href "https://guide.elm-lang.org" ] [text "GMSC10.100AA.000_000_003"]]
                , Table.td [] [ text "MAAAAAAAAAAAAAVAVAVAAA" ]
                , Table.td [] [ text "-" ]
                , Table.td [] [ text "soil" ]
                , Table.td [] [ text "High quality" ]
                ]
            ]
    }



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
