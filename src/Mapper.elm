module Mapper exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid

import Html.Attributes as HtmlAttr
import Html.Attributes exposing (..)
import Browser
import Dict
import Markdown
import View exposing (View)

import Bootstrap.Table as Table
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Json.Decode as D

import Http

type alias HitsResult = 
    { e: Float
    , id: String
    , identity: Float
    }

type alias SequenceResult =
    { aa: String
    , habitat: String
    , hits: List HitsResult
    , quality: String
    , tax: String
    }

type alias QueryResult =
  { seqid : String
  , aa : String
  , habitat: String
  , hits: List HitsResult
  , quality: String
  , tax: String
  }

type APIResult =
        APIResultOK { search_id : String
                    , status : String
                    }
        | APIError String

type SearchResult = 
        SearchResultOK { results: Maybe (Dict.Dict String (Dict.Dict String QueryResult))
                       , search_id : String
                       , status : String
                       }
        | SearchResultError String


decodeAPIResult : D.Decoder APIResult
decodeAPIResult =
    let
        bAPIResultOK i s = APIResultOK { search_id = i, status = s }
    in D.map2 bAPIResultOK
        (D.field "search_id" D.string)
        (D.field "status" D.string)

seqToquery : String -> SequenceResult -> QueryResult
seqToquery seqid { aa, habitat, hits, quality, tax } =
  QueryResult seqid aa habitat hits quality tax

decodeSequenceResult : D.Decoder SequenceResult
decodeSequenceResult = 
    D.map5 SequenceResult
        (D.field "aminoacid" D.string)
        (D.field "habitat" D.string)
        (D.field "hits" (D.list decodeHitsResult))
        (D.field "quality" D.string)
        (D.field "taxonomy" D.string)

decodeQueryResult : D.Decoder (Dict.Dict String QueryResult)
decodeQueryResult =
  D.map (Dict.map seqToquery) (D.dict decodeSequenceResult)

decodeSearchResult : D.Decoder SearchResult
decodeSearchResult = 
    let
        bSearchResultOK r i s = SearchResultOK { results = r, search_id = i, status = s }
    in D.map3 bSearchResultOK
        (D.maybe (D.field "results"  (D.dict decodeQueryResult)))
        (D.field "search_id" D.string)
        (D.field "status" D.string)

decodeHitsResult : D.Decoder HitsResult
decodeHitsResult = 
    D.map3 HitsResult
        (D.field "evalue" D.float)
        (D.field "id" D.string)
        (D.field "identity" D.float)


type Model =
    Loading
    | LoadError String
    | Results APIResult
    | Search SearchResult



type Msg
    = ResultsData (Result Http.Error APIResult)
    | SearchData (Result Http.Error SearchResult)

init : flags -> (Model, Cmd Msg)
init myFlags =
    ( Loading
    , Http.post
    { url = "http://127.0.0.1:5000/internal/seq-search/"
    , body = Http.multipartBody
                [ Http.stringPart "form" "sequence_faa=$(>seq\nMSSAAAA\n)"
                ]
    , expect = Http.expectJson ResultsData decodeAPIResult
    }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResultsData r -> case r of
            Ok v -> case v of 
                      APIResultOK ok ->
                        ( Results v
                        , Http.get { url = ("http://127.0.0.1:5000/internal/seq-search/" ++ ok.search_id)
                                   , expect = Http.expectJson SearchData decodeSearchResult
                                   }
                        )
                      APIError s -> (model,Cmd.none)                    
            Err err -> case err of
                Http.BadUrl s -> (LoadError ("Bad URL: "++ s) , Cmd.none)
                Http.Timeout  -> (LoadError ("Timeout") , Cmd.none)
                Http.NetworkError -> (LoadError ("Network error!") , Cmd.none)
                Http.BadStatus s -> (LoadError (("Bad status: " ++ String.fromInt s)) , Cmd.none)
                Http.BadBody s -> (LoadError (("Bad body: " ++ s)) , Cmd.none)

        SearchData sd -> case sd of
            Ok v -> ( Search v, Cmd.none )
                    {- case v of 
                      SearchResultOK ok ->
                        if ok.status == "Done" then
                           ( Search v, Cmd.none )
                        else
                           ( Loading, Cmd.none)
                      SearchResultError s -> (model,Cmd.none)-}
            Err err -> case err of
                Http.BadUrl s -> (LoadError ("Bad URL: "++ s) , Cmd.none)
                Http.Timeout  -> (LoadError ("Timeout") , Cmd.none)
                Http.NetworkError -> (LoadError ("Network error!") , Cmd.none)
                Http.BadStatus s -> (LoadError (("Bad status: " ++ String.fromInt s)) , Cmd.none)
                Http.BadBody s -> (LoadError (("Bad body: " ++ s)) , Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ ]


main: Program () Model Msg
main =
    Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

view : Model -> Browser.Document Msg
view model =
    { title = "AMP Prediction"
    , body =
        [ CDN.stylesheet
        , CDN.fontAwesome
        , Grid.container []
            [ Grid.simpleRow
                [ Grid.col []
                    [ 
                     viewModel model
                    ]
                ]
            ]
        ]
    }


viewModel : Model-> Html Msg
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
        Results r -> viewResults r
        Search s -> viewSearch s


viewResults r  = case r of
    APIResultOK ok ->
        div []
        [ text ok.search_id
        ]
    APIError err ->
        div []
            [ Html.p [] [ Html.text "Call to the GMSC server failed" ]
            , Html.blockquote []
                [ Html.p [] [ Html.text err ] ]
            ]

viewSearch s  = case s of
    SearchResultOK ok ->
        if ok.status == "Done" then
          div []
          [ text ok.search_id
          ]
        else
          div []
          [ text ok.status
          ]
    SearchResultError err ->
        div []
            [ Html.p [] [ Html.text "Call to the GMSC server failed" ]
            , Html.blockquote []
                [ Html.p [] [ Html.text err ] ]
            ]