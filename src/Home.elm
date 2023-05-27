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
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import Bootstrap.Carousel as Carousel exposing (defaultStateOptions)
import Bootstrap.Card as Card
import Bootstrap.Text as Text
import Bootstrap.Card.Block as Block

import Shared exposing (..)

type OperationType = Contigs | Proteins

type alias IdentifierQueryModel =
    { optype : Maybe OperationType
    , idcontent : String
    , seqcontent: String
    , carouselState : Carousel.State
    }

        
type Model =
        IdentifierQuery IdentifierQueryModel

type Msg
    = SelectOp OperationType
    | SetIdentifierExample
    | SetSeqExample
    | ClearId
    | ClearSeq
    | CarouselMsg Carousel.Msg

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        IdentifierQuery qm ->
            Carousel.subscriptions qm.carouselState CarouselMsg

-- INIT

myOptions =
    { defaultStateOptions
        | interval = Nothing
        , pauseOnHover = False
    }

init : flags -> ( Model, Cmd Msg )
init _ =
    ( IdentifierQuery 
        { optype = Nothing
        , idcontent = "" 
        , seqcontent = ""
        , carouselState = Carousel.initialStateWithOptions myOptions
        }
    , Cmd.none
    )

-- UPDATE

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
        SelectOp p -> 
          ifQuery <| \qmodel ->
                -- If the example input is selected, switch it
                if qmodel.optype == Just Contigs && qmodel.seqcontent == contigExample && p == Proteins then
                    ( { qmodel | optype = Just Proteins, seqcontent = "" }, Cmd.none )
                else if qmodel.optype == Just Proteins && qmodel.seqcontent == proteinExample && p == Contigs then
                    ( { qmodel | optype = Just Contigs, seqcontent = "" }, Cmd.none )
                else
                    ( { qmodel | optype = Just p, seqcontent = ""}, Cmd.none )
        
        SetIdentifierExample ->
          ifQuery <| \qmodel ->
            ( { qmodel | idcontent = identifierExample }, Cmd.none )

        SetSeqExample -> 
          ifQuery <| \qmodel ->
            let
              nc =
                case qmodel.optype of
                  Nothing -> -- When click example without selecting contig or protein
                    "Please select contig or protein mode above."
                  Just Contigs ->
                    contigExample
                  Just Proteins ->
                    proteinExample
            in
              ( { qmodel | seqcontent = nc }, Cmd.none )

        ClearId -> 
          ifQuery <| \qmodel ->
            ( { qmodel | idcontent = "" }, Cmd.none )

        ClearSeq -> 
          ifQuery <| \qmodel ->
            ( { qmodel | seqcontent = "" }, Cmd.none )

        CarouselMsg subMsg ->
          ifQuery <| \qmodel ->
            ({ qmodel | carouselState = Carousel.update subMsg qmodel.carouselState }, Cmd.none)

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
                        , intro
                        , viewSearch model
                        , viewFig model
                        , Html.hr [] []
                        , Shared.footer
                        ]
                    ]
                ]
            ]
        }
    

viewSearch : Model -> Html Msg
viewSearch model = 
  case model of
    IdentifierQuery qm -> 
      search qm

viewFig : Model -> Html Msg
viewFig model = 
  case model of
    IdentifierQuery qm -> 
      fig qm

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

search : IdentifierQueryModel -> Html Msg
search model = 
  let
    buttonStyle who active =
            case active of
                Nothing ->
                    [ Button.outlineInfo, Button.onClick (SelectOp who) ]

                Just p ->
                    if who == p then
                        [ Button.info, Button.onClick (SelectOp who) ]

                    else
                        [ Button.outlineInfo, Button.onClick (SelectOp who) ]
  in div [class "search"]
        [ Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ h4 [] [ text "Find homologues by sequence (GMSC-mapper) or search by identifier"]
                ]
            ]  
        , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ Form.group []
                    [ Form.label [] [ text "Identifier" ]
                    , Input.text [ Input.value model.idcontent,Input.attrs [ placeholder "GMSC10.100AA_XXX_XXX_XXX   or   GMSC10.90AA_XXX_XXX_XXX" ] ]
                    , Button.button [ Button.outlineSecondary, Button.attrs [ class "float-right"], Button.onClick SetIdentifierExample] [ text "Example" ]
                    , Button.button[ Button.light, Button.attrs [ class "float-right"], Button.onClick ClearId] [ text "Clear" ]   
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
                    [ ButtonGroup.button (buttonStyle Contigs model.optype) [ text "Search from contigs" ]
                    , ButtonGroup.button (buttonStyle Proteins model.optype) [ text "Search from proteins" ]
                    ]
                ]
            ]
       , Form.row [] 
            [ Form.col [ Col.sm10 ]
                [ Form.group []
                    [ label [ for "myarea"] [ text "Input an amino acid / nucleotide sequence in FASTA format"]
                    , Textarea.textarea
                        [ Textarea.id "myarea"
                        , Textarea.value model.seqcontent
                        , Textarea.rows 3
                        , case model.optype of
                            Nothing ->
                              Textarea.attrs [ placeholder "" ]
                            Just p ->
                              if p == Contigs then
                                Textarea.attrs [ placeholder ">contigID\n AATACTACATGTCA..." ]
                              else
                                Textarea.attrs [ placeholder ">proteinID\n MTIISR..." ]
                        ]
                    , Button.button[ Button.outlineSecondary,Button.attrs [ class "float-right"], Button.onClick SetSeqExample] [ text "Example" ]
                    , Button.button[ Button.light,Button.attrs [ class "float-right"], Button.onClick ClearSeq] [ text "Clear" ]   
                    , Button.button[ Button.info,Button.attrs [ class "float-right"]] [ text "Submit" ]        
                    ]
                ]
            ]  
        ]

fig: IdentifierQueryModel -> Html Msg
fig model = 
  div [class "fig"]
    [ Carousel.config CarouselMsg []
        |> Carousel.withControls
        |> Carousel.withIndicators
        |> Carousel.slides
            [Slide.config []
              (Slide.customContent
                (
                Card.config
                    [ Card.light
                    , Card.attrs [ ]
                    , Card.align Text.alignSmCenter
                    ]
                    |> Card.headerH4 [] 
                        [ img [ src "assets/home_geo.svg" ] []
                        , p [] [text " Geographical distribution"]
                        ]
                    |> Card.view
                )        
              )
            , Slide.config []
              (Slide.customContent
                (
                Card.config
                    [ Card.light
                    , Card.attrs [ ]
                    , Card.align Text.alignSmCenter
                    ]
                    |> Card.headerH4 [] 
                        [ img [ src "assets/home_taxonomy.svg" ] []
                        , p [] [text " Taxonomy distribution"]
                        ]
                    |> Card.view
                )        
              )
            ]
        |> Carousel.view model.carouselState
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