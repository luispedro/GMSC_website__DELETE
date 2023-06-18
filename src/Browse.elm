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
import Selects
import Selectshared
import Shared
import Selectitem

type alias SelectModel =
    { hq: Bool
    , habitatSearch : Selectshared.Model Selectitem.Habitat
    , taxonomySearch : Selectshared.Model Selectitem.Taxonomy
    }

type Model 
    = Select SelectModel
    | FilterModel Filter.Model

type Msg 
    = Search
    | FilterMsg Filter.Msg
    | HabitatSearchMsg (Selectshared.Msg Selectitem.Habitat)
    | TaxonomySearchMsg (Selectshared.Msg Selectitem.Taxonomy)
    | NoOp

initialModel : Model
initialModel =
    Select 
        { hq = True
        , habitatSearch = Selectshared.initialModel 
                               { id = "exampleEmptySearch"
                               , available = Selectitem.habitat
                               , itemToLabel = Selectitem.habitattoLabel
                               , selected = [ ]
                               , selectConfig = selectConfigHabitatSearch
                               }
        , taxonomySearch = Selectshared.initialModel 
                               { id = "exampleEmptySearch"
                               , available = Selectitem.taxonomy
                               , itemToLabel = Selectitem.taxtoLabel
                               , selected = [ ]
                               , selectConfig = selectConfigTaxonomySearch
                               }
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
        NoOp ->
            ( model, Cmd.none )

        HabitatSearchMsg sub ->
            ifQuery <| \qmodel ->
              let
                ( subModel, subCmd ) =
                    Selectshared.update
                        sub
                        qmodel.habitatSearch
              in
                ( { qmodel | habitatSearch = subModel }
                , Cmd.map HabitatSearchMsg subCmd
            )

        TaxonomySearchMsg sub ->
            ifQuery <| \qmodel ->
              let
                ( subModel, subCmd ) =
                    Selectshared.update
                        sub
                        qmodel.taxonomySearch
              in
                ( { qmodel | taxonomySearch = subModel }
                , Cmd.map TaxonomySearchMsg subCmd
            )
              
        Search ->
          case model of
            Select hm ->
                let (qhabitat,qtaxonomy) = ( (String.join "," <| List.sort (List.map hm.habitatSearch.itemToLabel hm.habitatSearch.selected))
                                           , (String.join "," <| List.map hm.taxonomySearch.itemToLabel hm.taxonomySearch.selected))
                in
                  let
                    (sm, cmd) = Filter.initialState qhabitat qtaxonomy
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
    Sub.none

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
        [ h5 [] [text "Browse by habitats and taxonomy"]
        , Selectshared.view
            model.habitatSearch
            "Browse by habitats"
            |> Html.map HabitatSearchMsg
        , Selectshared.view
            model.taxonomySearch
            "Browse by taxonomy"
            |> Html.map TaxonomySearchMsg
        , div [class "browse"] [Button.button [ Button.info, Button.onClick Search] [ text "Browse" ]]
        ]

viewResult : Model -> Html Msg
viewResult model = case model of
    FilterModel m ->
        Filter.viewModel m
            |> Html.map FilterMsg
    Select m -> 
        Html.text ""

selectConfigHabitatSearch =
    Selects.newConfig
        { onSelect = Selectshared.OnSelect
        , toLabel = .label
        , filter = Shared.filter 1 .label
        , toMsg = Selectshared.SelectMsg
        }
        -- |> Selects.withCutoff 12
        |> Selects.withEmptySearch True
        |> Selects.withNotFound "No matches"
        |> Selects.withPrompt "Select habitats"

selectConfigTaxonomySearch =
    Selects.newConfig
        { onSelect = Selectshared.OnSingleSelect
        , toLabel = .label
        , filter = Shared.filter 1 .label
        , toMsg = Selectshared.SelectMsg
        }
        -- |> Selects.withCutoff 12
        |> Selects.withEmptySearch True
        |> Selects.withNotFound "No matches"
        |> Selects.withPrompt "Select taxonomy"