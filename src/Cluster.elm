module Cluster exposing (Model(..), Msg(..), initialState, update, viewModel)

import Html
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes as HtmlAttr
import Html.Attributes exposing (..)
import Browser
import Dict
import Markdown
import Http

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Table as Table
import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Json.Decode as D

import View exposing (View)
import Shared exposing (..)

type Model =
    Loading
    | LoadError String
    | Loaded { aa: String
             , habitat: String
             , nuc: String
             , seqid: String
             , tax: String
             , showtype: Bool
             }

type APIResult =
    APIError String
    | APIResultOK { aa: String
                  , habitat: String
                  , nuc: String
                  , seqid: String
                  , tax: String
                  , showtype: Bool
                  }

type Msg
    = ResultsData ( Result Http.Error APIResult )
    | Showmember

decodeAPIResult : D.Decoder APIResult
decodeAPIResult =
    let
        bAPIResultOK a h n s t = APIResultOK { aa = a, habitat = h, nuc = n, seqid = s, tax=t, showtype=False}
    in D.map5 bAPIResultOK
        (D.field "aminoacid" D.string)
        (D.field "habitat" D.string)
        (D.field "nucleotide" D.string)
        (D.field "seq_id" D.string)
        (D.field "taxonomy" D.string)


initialState : String -> (Model, Cmd Msg)
initialState seq_id =
    ( Loading
    , Http.get
    { url = ("http://127.0.0.1:5001/v1/seq-info/" ++ seq_id)
    , expect = Http.expectJson ResultsData decodeAPIResult
    }
    )

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        ifQuery f =
          case model of
            Loaded v ->
                let
                    (qmpost, c) = f v
                in (Loaded qmpost, c)   
            Loading -> 
                (Loading,Cmd.none) 
            LoadError _ -> 
                (LoadError "",Cmd.none) 
    in case msg of
        ResultsData r -> case r of
            Ok (APIResultOK v) -> ( Loaded v, Cmd.none )
            Ok (APIError e) -> ( LoadError e, Cmd.none )
            Err err -> case err of
                Http.BadUrl s -> (LoadError ("Bad URL: "++ s) , Cmd.none)
                Http.Timeout  -> (LoadError ("Timeout") , Cmd.none)
                Http.NetworkError -> (LoadError ("Network error!") , Cmd.none)
                Http.BadStatus s -> (LoadError (("Bad status: " ++ String.fromInt s)) , Cmd.none)
                Http.BadBody s -> (LoadError (("Bad body: " ++ s)) , Cmd.none)
        Showmember -> 
           ifQuery <| \qmodel ->
            ( { qmodel | showtype = True }, Cmd.none )


viewModel : Model -> Html Msg
viewModel model =
    case model of
        Loading ->
                div []
                    [ text "Loading..."
                    ]
        LoadError e ->
                div []
                    [ text "Error "
                    , text e
                    ]
        Loaded v ->
                div [] 
                  [ h1 [] [text v.seqid]
                  , Table.table 
                        { options = [ Table.striped, Table.small,Table.hover]
                        , thead =  Table.simpleThead []
                        , tbody = Table.tbody []
                            [ Table.tr []
                                [ Table.td [] [p [id "title"] [text "Consensus sequence"]  ]
                                , Table.td [] [p [id "detail"] [text v.aa] ]
                                ]
                            , Table.tr []
                                [ Table.td [] [ p [id "title"] [text "Taxonomic assignment"] ]
                                , Table.td [] [ p [id "detail"] [text v.tax] ]
                                ]
                            , Table.tr []
                                [ Table.td [] [ p [id "title"] [text "Habitat"]  ]
                                , Table.td [] [ p [id "detail"] [text v.habitat]  ]
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
                  , title
                  , if v.showtype
                      then 
                        members
                    else 
                      Html.text ""
                  -- , page_select
                  ]

-- main text
title : Html Msg
title = div [ id "cluster" ] 
                [ h4 [id "cluster"] 
                       [ text  "This 90AA cluster contains the following 100AA smORFs:"]
                , Button.button [ Button.info, Button.onClick (Showmember)] [ text "Show" ]
                , Button.button [ Button.light] [ text "Download .csv" ]
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


{-
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
-}
