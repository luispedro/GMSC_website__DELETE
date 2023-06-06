module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing(..)
import Html.Attributes as HtmlAttr
import Html.Events exposing (..)
import Browser
import Dict
import Markdown
import View exposing (View)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import Bootstrap.Carousel as Carousel exposing (defaultStateOptions)
import Bootstrap.Card as Card
import Bootstrap.Text as Text
import Bootstrap.Card.Block as Block

import Home
import Sequence
import Cluster
import Download
import Help
import About
import Browse



type Model =
    HomeModel Home.Model
    | SequenceModel Sequence.Model
    | ClusterModel Cluster.Model
    | BrowseModel Browse.Model
    | DownloadModel 
    | HelpModel
    | AboutModel

type Msg
    = HomeMsg Home.Msg
    | BrowseMsg Browse.Msg
    | SequenceMsg Sequence.Msg
    | ClusterMsg Cluster.Msg
    | GoToHome
    | GoToBrowse
    | GoToDownload
    | GoToHelp
    | GoToAbout

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT
init : flags -> ( Model, Cmd Msg )
init _ =
    ( HomeModel Home.initialModel
    , Cmd.none
    )

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg)
update msg model = case msg of
    HomeMsg Home.SubmitIdentifier -> case model of
        HomeModel (Home.IdentifierQuery hm) ->
            if String.startsWith "GMSC10.100AA" hm.idcontent
              then
                let
                  (sm, cmd) = Sequence.initialState hm.idcontent
                in ( SequenceModel sm, Cmd.map SequenceMsg cmd )
            else  
                let
                  (sm, cmd) = Cluster.initialState hm.idcontent
                in ( ClusterModel sm, Cmd.map ClusterMsg cmd )
        _ -> ( model, Cmd.none )

    GoToHome ->
        ( HomeModel Home.initialModel, Cmd.none )

    GoToBrowse ->
        ( BrowseModel Browse.initialModel, Cmd.none )
    
    GoToDownload ->
        ( DownloadModel, Cmd.none )

    GoToHelp ->
        ( HelpModel, Cmd.none )

    GoToAbout ->
        ( AboutModel, Cmd.none )   

    HomeMsg m -> case model of
        HomeModel hm ->
            let
                (nhm, cmd) = Home.update m hm
            in
                ( HomeModel nhm, Cmd.map HomeMsg cmd )
        _ -> ( model, Cmd.none )
    
    BrowseMsg m -> case model of
        BrowseModel bm ->
            let
                (nbm, cmd) = Browse.update m bm
            in
                ( BrowseModel nbm, Cmd.map BrowseMsg cmd )
        _ -> ( model, Cmd.none )

    SequenceMsg m -> case model of
        SequenceModel sm ->
            let
                (nqm, cmd) = Sequence.update m sm
            in
                ( SequenceModel nqm, Cmd.map SequenceMsg cmd )
        _ -> ( model, Cmd.none )

    ClusterMsg m -> case model of
        ClusterModel sm ->
            let
                (nqm, cmd) = Cluster.update m sm
            in
                ( ClusterModel nqm, Cmd.map ClusterMsg cmd )
        _ -> ( model, Cmd.none )

main: Program () Model Msg
main =
    Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

view : Model -> Browser.Document Msg
view model = { title = "GMSC:Home"
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
                        [ header
                        , viewModel model
                        , Html.hr [] []
                        , footer
                        ]
                    ]
                ]
            ]
        }

viewModel : Model -> Html Msg
viewModel model = case model of
    HomeModel m ->
        Home.viewModel m
            |> Html.map HomeMsg
    SequenceModel m ->
        Sequence.viewModel m
            |> Html.map SequenceMsg
    ClusterModel m ->
        Cluster.viewModel m
            |> Html.map ClusterMsg       
    BrowseModel m ->
        Browse.viewModel m
            |> Html.map BrowseMsg     
    DownloadModel ->
        Download.viewModel 
    HelpModel ->
        Help.viewModel 
    AboutModel ->
        About.viewModel

-- header


header : Html Msg
header =
    div [id "topbar"]
        [Grid.simpleRow
            [ Grid.col [] [ Html.a [href "#", onClick GoToHome] [Html.text "Home"]] 
            , Grid.col [] [ Html.a [href "#", onClick GoToBrowse] [Html.text "Browse"]] 
            , Grid.col [] [ Html.a [href "#", onClick GoToDownload] [Html.text "Downloads"]]
            , Grid.col [] [ Html.a [href "#", onClick GoToHelp] [Html.text "Help"]]
            , Grid.col [] [ Html.a [href "#", onClick GoToAbout] [Html.text "About&Contact"]]
            ]
        ]

-- FOOTER


footer : Html Msg
footer =
  div [id "footerbar"]
      [ a [][ text "Copyright (c) 2023 GMSC authors. All rights reserved."]
      ]

