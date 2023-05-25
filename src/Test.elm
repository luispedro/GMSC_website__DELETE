module Test exposing (main)

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

import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown

import Shared exposing (..)

type alias Model =
    { myDrop1State : Dropdown.State
    }

type Msg
    = MyDrop1Msg Dropdown.State

init : (Model, Cmd Msg )
init =
    ( { myDrop1State = Dropdown.initialState} -- initially closed
    , Cmd.none
    )

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MyDrop1Msg state ->
            ( { model | myDrop1State = state }
            , Cmd.none
            )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg ]

main: Program () Model Msg
main =
    Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

view : () -> Browser.Document Msg
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
    div []
        [ Dropdown.dropdown
            model.myDrop1State
            { options = []
            , toggleMsg = MyDrop1Msg
            , toggleButton =
                Dropdown.toggle [ Button.primary ] [ text "My dropdown" ]
            , items =
                [ Dropdown.buttonItem [] [ text "Item 1" ]
                , Dropdown.buttonItem [] [ text "Item 2" ]
                ]
            }
        ]