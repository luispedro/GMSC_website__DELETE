module Home exposing (..)
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
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea

import Shared exposing (..)



type alias IdentifierQueryModel =
    { facontent : String
    }

type Model =
        IdentifierQuery IdentifierQueryModel

type Msg
    = SetExample
    | Cleartext

init : flags -> ( Model, Cmd Msg )
init _ =
    ( IdentifierQuery { facontent = ""}
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    let
        ifQuery f = 
          case model of
            IdentifierQuery qm ->
                let
                    (qmpost, c) = f qm
                in (IdentifierQuery qmpost, c)
    in case msg of
        SetExample -> 
          ifQuery <| \qmodel ->
            ( { qmodel | facontent = identifierExample }, Cmd.none )
        Cleartext -> 
          ifQuery <| \qmodel ->
            ( { qmodel | facontent = "" }, Cmd.none )


main: Program () Model Msg
main =
    Browser.document
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
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
                        , intro
                        , viewModel model
                        , content_geo
                        , content_habitat
                        , content_taxonomy
                        , Html.hr [] []
                        , Shared.footer
                        ]
                    ]
                ]
            ]
        }
    

viewModel : Model -> Html Msg
viewModel model = 
  case model of
    IdentifierQuery qm -> 
      search qm

-- main text


intro : Html msg
intro =
    span [id "introduction"]
        [Markdown.toHtml [] """
# Global Microbial smORFs Catalog v1.0

The global microbial smORF catalogue (GMSC) is an integrated, consistently-processed, smORFs catalog of the microbial world, combining publicly available metagenomes and high-quality isolated microbial genomes.
A total of non-redundant 965 million 100AA ORFs were predicted from 63,410 metagenomes from global habitats and 87,920 high-quality isolated microbial genomes from the [ProGenomes](https://progenomes.embl.de/) database.
The smORFs were clustered at 90% amino acid identity resulting in 288 million 90AA smORFs families.

- The annotation of GMSC contains: 
  - taxonomy classification
  - habitat assignment
  - quality assessment
  - conserved domain annotation
  - cellular localization prediction
""" ]


content_geo : Html msg
content_geo =
    span [id "content"]
        [Markdown.toHtml [] """
##### Geographical distribution
![Geographical distribution](assets/home_geo.svg)
""" ]

content_habitat : Html msg
content_habitat =
    span [id "content"]
        [Markdown.toHtml [] """
##### Habitat distribution
""" ]

content_taxonomy : Html msg
content_taxonomy =
    span [id "home"]
        [Markdown.toHtml [] """
##### Taxonomy distribution
![Taxonomy distribution](assets/home_taxonomy.svg)
""" ]

search : IdentifierQueryModel -> Html Msg
search model = 
  div [class "search"]
        [ Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ h4 [] [ text "Find homologues by sequence (GMSC-mapper) or search by identifier"]
                ]
            ]  
        , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ Form.group []
                    [ Form.label [] [ text "Identifier" ]
                    , Input.text [ Input.value model.facontent,Input.attrs [ placeholder "GMSC10.100AA_XXX_XXX_XXX   or   GMSC10.90AA_XXX_XXX_XXX" ] ]
                    , Button.button [ Button.outlineSecondary, Button.attrs [ class "float-right"], Button.onClick SetExample] [ text "Example" ]
                    , Button.button[ Button.light, Button.attrs [ class "float-right"], Button.onClick Cleartext] [ text "Clear" ]   
                    , Button.button[ Button.info, Button.attrs [ class "float-right"]] [ text "Submit" ] 
                    ]            
                ]
            ]
        , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ h6 [] [ text "This webserver allows you to use GMSC-mapper for short jobs. For larger jobs, you can download and use the "
                        , a [href "https://github.com/BigDataBiology/GMSC-mapper"] [text "command line version of the tool."]]
                ]
            ] 
        , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ ButtonGroup.buttonGroup [ ButtonGroup.small ]
                    [ ButtonGroup.button [ Button.outlineInfo ] [ text "Search from contigs" ]
                    , ButtonGroup.button [ Button.outlineInfo,Button.attrs [ class "ml-3" ]] [ text "Search from proteins" ]
                    ]
                ]
            ]
       , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ Form.group []
                    [ label [ for "myarea"] [ text "Input an amino acid / nucleotide sequence in FASTA format"]
                    , Textarea.textarea
                        [ Textarea.id "myarea"
                        , Textarea.rows 3
                        , Textarea.attrs [ placeholder ">contigID\n AATACTACATGTCA..." ]
                        ]
                    , Button.button[ Button.outlineSecondary,Button.attrs [ class "float-right"]] [ text "Example" ]
                    , Button.button[ Button.light,Button.attrs [ class "float-right"]] [ text "Clear" ]   
                    , Button.button[ Button.info,Button.attrs [ class "float-right"]] [ text "Submit" ]        
                    ]
                ]
            ]            
        ]
        
identifierExample : String
identifierExample = "GMSC10.100AA_000_000_000"

contigExample : String
contigExample = """>scaffold1
CTTCTGATCTTTACGCAGCATTGTGTGTTTCCACCTTTCAAAAAATTCTCCGTGAACTGC
GCCCTGGGAGTGGTGAAATCCTCCGCGGAACGAAGTCCCGGAATTGCGCACAAATTCACG
TGCTGAACAATTTTACCATAGGAATGTGCGGTTGTAAAGAGAAAAATGCAAAAAATTCCT
TATTTTTATAAAAGGAGCGGGGAAAAGAGGCGGAAAATATTTTTTTGAAAGGGGATTGAC
AGAGAGAAACGGCCGTGTTATCCTAACTGTACTAACACACATAGTACAGTTGGTACAGTT
CGGAGGAACGTTATGAAGGTCATCAAGAAGGTAGTAGCCGCCCTGATGGTGCTGGGAGCA
CTGGCGGCGCTGACGGTAGGCGTGGTTTTGAAGCCGGGCCGGAAAGGAGACGAAACATGA
TGCTGTTTGGTTTTGCGGGGATCGCCGCCATCGTGGGTCTGATTTTTGCCGCTGTTGTTC
TGGTGTCCGTGGCCTTGCAGCCCTGAGAACGGGGCAGATGCAATGAGTACGCTGTTTTTG
CTTGGTATCGCAGGCGCGGTACTGCTGGTTATTTTGCTGACAGCGGTGATCCTGCACCGC
TGATCGAACATTCCTCAGAAAGGAGAGGCACACGTTCTGACATTGAATTACCGGGATTCC
CGTCCCATTTATGAACAGATCAAGGACGGCCTGCGGCGGATGATCGTCACCGGGGCC"""

proteinExample : String
proteinExample = """>smORF1
MTIISRNLFHFETVSRSLGIETEMNPFLGKHLNHQLIWCGLHGFGTAQAQAIGTEMQTNFRLFFAEFFPRFQDKPGARPLRRINPQGNLHIRFRC"""