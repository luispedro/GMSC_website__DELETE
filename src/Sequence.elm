module Sequence exposing (..)
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
# GMSC10.100AA.000_000_009
""" ]

content : Html msg
content = Table.table
    { options = [ Table.striped, Table.small,Table.hover]
    , thead =  Table.simpleThead []
    , tbody =
        Table.tbody []
            [ Table.tr []
                [ Table.td [] [p [id "title"] [text "Protein sequence"]  ]
                , Table.td [] [p [id "detail"] [text "MAAAAAAAAAADAGDEDAAFTVDSAEGHELAWHAVQELEYLSD"] ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Length"] ]
                , Table.td [] [ p [id "detail"] [text "43"] ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Taxonomic assignment"]  ]
                , Table.td [] [ p [id "detail"] [text "f__Streptosporangiaceae"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Habitat"]  ]
                , Table.td [] [ p [id "detail"] [text "soil"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Protein cluster"]  ]
                , Table.td [] [a [ href "https://guide.elm-lang.org" ] [ text "GMSC10.90AA.000_000_083" ]]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Conserved domain"]  ]
                , Table.td [] [ p [id "detail"] [text "-"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Cellular localization"]  ]
                , Table.td [] [ p [id "detail"] [text "-"]  ]
                ]
            , Table.tr []
                [ Table.td [] [ p [id "title"] [text "Quality"]  ]
                , Table.td [] [ p [id "detail"] [text "High quality"]  ]
                ]
            ]
    }