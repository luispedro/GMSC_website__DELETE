module Main exposing (main)

import Html exposing (..)
import Html.Attributes as HtmlAttr
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

import Shared
import Home
import Sequence
import Cluster



type Model =
    HomeModel Home.Model
    -- | IdentifierQuery IdentifierQuery.Model
    | SequenceModel Sequence.Model
    | ClusterModel Cluster.Model
    -- | StaticPage StaticPage.Model

type ChangePage
    = GoToHome
    | GoToBrowse
    | GoToDownloads
    | GoToHelp
    | GoToAbout
    -- | StaticPage

type Msg
    = HomeMsg Home.Msg
    -- | IdentifierQueryMsg IdentifierQuery.Msg
    | SequenceMsg Sequence.Msg
    | ClusterMsg Cluster.Msg
    -- | StaticPageMsg StaticPage.Msg
    | GlobalMsg ChangePage

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
    GlobalMsg _ -> ( model, Cmd.none )
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
    HomeMsg m -> case model of
        HomeModel hm ->
            let
                (nhm, cmd) = Home.update m hm
            in
                ( HomeModel nhm, Cmd.map HomeMsg cmd )
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
    {-
    SequenceQueryMsg m -> case model of
        SequenceQuery qm ->
            let
                (nqm, cmd) = SequenceQuery.update m qm
            in
                ( SequenceQuery nqm, Cmd.map SequenceQueryMsg cmd )
        _ -> ( model, Cmd.none )
    StaticPageMsg m -> case model of
        StaticPage spm ->
            let
                (nspm, cmd) = StaticPage.update m spm
            in
                ( StaticPage nspm, Cmd.map StaticPageMsg cmd )
        _ -> ( model, Cmd.none )
    -}

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
                        [ Shared.header
                        , viewModel model
                        , Html.hr [] []
                        , Shared.footer
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
    --IdentifierQueryModel m -> IdentifierQuery.view m
    SequenceModel m ->
        Sequence.viewModel m
            |> Html.map SequenceMsg
    ClusterModel m ->
        Cluster.viewModel m
            |> Html.map ClusterMsg            
    --StaticPageModel m -> StaticPage.view m

