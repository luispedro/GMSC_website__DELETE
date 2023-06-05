module Sequence exposing (Model(..), Msg(..), initialState, update, viewModel)

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
import Bootstrap.Button as Button
import Bootstrap.Table as Table
import Json.Decode as D

import View exposing (View)

type Model =
    Loading
    | LoadError String
    | Loaded { aa: String
             , habitat: String
             , nuc: String
             , seqid: String
             , tax: String
             }

type APIResult =
    APIError String
    | APIResultOK { aa: String
                  , habitat: String
                  , nuc: String
                  , seqid: String
                  , tax: String
                  }

type Msg
    = ResultsData ( Result Http.Error APIResult )


decodeAPIResult : D.Decoder APIResult
decodeAPIResult =
    let
        bAPIResultOK a h n s t = APIResultOK { aa = a, habitat = h, nuc = n, seqid = s, tax=t }
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
    case msg of
        ResultsData r -> case r of
            Ok (APIResultOK v) -> ( Loaded v, Cmd.none )
            Ok (APIError e) -> ( LoadError e, Cmd.none )
            Err err -> case err of
                Http.BadUrl s -> (LoadError ("Bad URL: "++ s) , Cmd.none)
                Http.Timeout  -> (LoadError ("Timeout") , Cmd.none)
                Http.NetworkError -> (LoadError ("Network error!") , Cmd.none)
                Http.BadStatus s -> (LoadError (("Bad status: " ++ String.fromInt s)) , Cmd.none)
                Http.BadBody s -> (LoadError (("Bad body: " ++ s)) , Cmd.none)


viewModel : Model-> Html.Html Msg
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
                    , Table.table { options = [ Table.striped, Table.small,Table.hover]
                                  , thead = Table.simpleThead []
                                  , tbody = Table.tbody []
                                      [ Table.tr []
                                          [ Table.td [] [p [id "title"] [text "Protein sequence"]  ]
                                          , Table.td [] [p [id "detail"] [text v.aa] ]
                                          ]
                                      , Table.tr []
                                          [ Table.td [] [ p [id "title"] [text "Nucleotide sequence"] ]
                                          , Table.td [] [ p [id "detail"] [text v.nuc] ]
                                          ]
                                      , Table.tr []
                                          [ Table.td [] [ p [id "title"] [text "Taxonomic assignment"]  ]
                                          , Table.td [] [ p [id "detail"] [text v.tax]  ]
                                          ]
                                      , Table.tr []
                                          [ Table.td [] [ p [id "title"] [text "Habitat"]  ]
                                          , Table.td [] [ p [id "detail"] [text v.habitat]  ]
                                          ]
                                      , Table.tr []
                                          [ Table.td [] [ p [id "title"] [text "Protein cluster"]  ]
                                          , Table.td [] [a [ href "https://guide.elm-lang.org" ] [ text "-" ]]
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
                                          , Table.td [] [ p [id "detail"] [text "-"]  ]
                                          ]
                                     ]
                                  }
                    ]
