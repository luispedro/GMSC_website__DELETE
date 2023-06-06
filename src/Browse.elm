module Browse exposing (Model(..), Msg(..), initialModel, update, viewModel)

import Html exposing (..)
import Html.Attributes as HtmlAttr
import Html.Attributes exposing (..)
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
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Card as Card
import Bootstrap.Text as Text
import Bootstrap.Card.Block as Block

import Filter

type alias SelectModel =
    { habitat : String
    , taxonomy: String
    , hq: Bool
    , myDrop1State : Dropdown.State
    , myDrop2State : Dropdown.State
    }

type Model 
    = Select SelectModel
    | FilterModel Filter.Model

type Msg 
    = SetHabitat String
    | SetTaxonomy String
    | Search
    | FilterMsg Filter.Msg
    | MyDrop1Msg Dropdown.State
    | MyDrop2Msg Dropdown.State    

initialModel : Model
initialModel =
    Select 
        { habitat = ""
        , taxonomy = ""
        , hq = True
        , myDrop1State = Dropdown.initialState
        , myDrop2State = Dropdown.initialState
        }


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    let
        ifQuery f = 
          case model of
            Select qm ->
                let
                    (qmpost, c) = f qm
                in (Select qmpost, c)
            FilterModel m ->
                (model,Cmd.none)
    in case msg of
        MyDrop1Msg state ->
          ifQuery <| \qmodel ->
            ( { qmodel | myDrop1State = state }
            , Cmd.none
            )

        MyDrop2Msg state ->
          ifQuery <| \qmodel ->
            ( { qmodel | myDrop2State = state }
            , Cmd.none
            )

        SetHabitat h ->
          ifQuery <| \qmodel ->
              ( { qmodel | habitat = h }, Cmd.none )

        SetTaxonomy t ->
          ifQuery <| \qmodel ->
              ( { qmodel | taxonomy = t }, Cmd.none )
              
        Search ->
          case model of
            Select hm->
                let
                  (sm, cmd) = Filter.initialState hm.habitat hm.taxonomy
                in ( FilterModel sm, Cmd.map FilterMsg cmd )
            FilterModel m ->
                (model,Cmd.none)

        FilterMsg m -> case model of
          FilterModel sm ->
            let
                (nqm, cmd) = Filter.update m sm
            in
                ( FilterModel nqm, Cmd.map FilterMsg cmd )
          Select am ->
            (model,Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Select qm ->
           Sub.batch
                [ Dropdown.subscriptions qm.myDrop1State MyDrop1Msg 
                , Dropdown.subscriptions qm.myDrop2State MyDrop2Msg ]
        FilterModel m ->
           Sub.batch [ ]

viewModel : Model -> Html Msg
viewModel model =
    Html.div []
        [ viewSearch model
        , viewResult model
        ]

viewSearch : Model -> Html Msg
viewSearch model =
  case model of
    Select qm ->
      search qm
    FilterModel m ->
      Html.text ""

search: SelectModel -> Html Msg
search model = div []
        [ h5 [] [text "Browse by habitats and/or taxonomy"]
        , InputGroup.config
            ( InputGroup.text [ Input.value model.habitat
                              , Input.placeholder "Search for"
                              , Input.onInput SetHabitat 
                              ] )
            |> InputGroup.predecessors
                [ InputGroup.dropdown
                    model.myDrop1State
                    { options = []
                    , toggleMsg = MyDrop1Msg
                    , toggleButton =
                        Dropdown.toggle [ Button.outlineSecondary ] [ text "Habitats" ]
                    , items =
                        [ Dropdown.buttonItem [] [ text "Soil"]
                        , Dropdown.buttonItem [] [ text "Marine"]
                        ]
                    }
                ]
            |> InputGroup.view
        , InputGroup.config
            ( InputGroup.text [ Input.value model.taxonomy
                              , Input.placeholder "Search for"
                              , Input.onInput SetTaxonomy
                              ] )
            |> InputGroup.predecessors
                [ InputGroup.dropdown
                    model.myDrop2State
                    { options = []
                    , toggleMsg = MyDrop2Msg
                    , toggleButton =
                        Dropdown.toggle [ Button.outlineSecondary ] [ text "Taxonomy" ]
                    , items =
                        [ Dropdown.buttonItem [] [ text "d__Bacteria"]
                        , Dropdown.buttonItem [] [ text "d__Archaea"]
                        ]
                    }
                ]
            |> InputGroup.view 
    , Button.button [ Button.light, Button.onClick Search] [ text "Search" ]
    ]

viewResult : Model -> Html Msg
viewResult model = case model of
    FilterModel m ->
        Filter.viewModel m
            |> Html.map FilterMsg
    Select m -> 
        Html.text ""