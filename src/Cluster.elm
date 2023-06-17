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
import Members


type Model =
    Loading
    | LoadError String
    | Loaded { aa: String
             , habitat: String
             , nuc: String
             , seqid: String
             , tax: String
             }
    | MembersModel Members.Model

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
    | Showmember
    | MembersMsg Members.Msg

decodeAPIResult : D.Decoder APIResult
decodeAPIResult =
    let
        bAPIResultOK a h n s t = APIResultOK { aa = a, habitat = h, nuc = n, seqid = s, tax=t}
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
    { url = ("https://gmsc-api.big-data-biology.org/v1/seq-info/" ++ seq_id)
    , expect = Http.expectJson ResultsData decodeAPIResult
    }
    )

update : Msg -> Model -> ( Model, Cmd Msg )
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
            MembersModel m ->
                (model,Cmd.none)
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
            case model of
              Loaded hm->
                let
                  (sm, cmd) = Members.initialState hm.seqid
                in ( MembersModel sm, Cmd.map MembersMsg cmd )
              Loading -> 
                (Loading,Cmd.none) 
              LoadError _ -> 
                (LoadError "",Cmd.none) 
              MembersModel m ->
                (model,Cmd.none)
        MembersMsg m -> case model of
          MembersModel tm ->
            let
                (nqm, cmd) = Members.update m tm
            in
                ( MembersModel nqm, Cmd.map MembersMsg cmd )
          Loaded hm->
                (model,Cmd.none)
          Loading -> 
                (Loading,Cmd.none) 
          LoadError _ -> 
                (LoadError "",Cmd.none) 


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
                                [ Table.td [] [p [id "title"] [text "Consensus protein sequence"]  ]
                                , Table.td [] [p [id "detail"] [text v.aa] ]
                                ]
                            , Table.tr []
                                [ Table.td [] [ p [id "title"] [text "Consensus nucleotide sequence"] ]
                                , Table.td [] [ p [id "detail"] [text v.nuc] ]
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
                  , viewMembers model]
                  -- , page_select
        MembersModel m ->
            div [] [viewMembers model]
                  

-- main text
title : Html Msg
title = div [ id "cluster" ] 
                [ h4 [id "cluster"] 
                       [ text  "This 90AA cluster contains the following 100AA smORFs:"]
                , Button.button [ Button.info, Button.onClick (Showmember)] [ text "Show" ]
                -- , Button.button [ Button.light] [ text "Download .csv" ]
                ]
viewMembers : Model -> Html Msg
viewMembers model = case model of
    MembersModel m ->
        Members.viewModel m
            |> Html.map MembersMsg
    Loaded m -> 
        Html.text ""
    Loading -> 
        Html.text ""
    LoadError _ -> 
        Html.text ""