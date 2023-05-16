module Download exposing (..)
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

import Center



main: Program () () Never
main =  
    Browser.document
    { init = \_ -> ((), Cmd.none)
    , update = \_ _ -> ((), Cmd.none)
    , subscriptions = \_ -> Sub.none
    , view = \_ ->
        { title = "GMSC:Downloads"
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
                        , content
                        , Html.hr [] []
                        , footer
                        ]
                    ]
                ]
            ]
        }
    }

content: Html msg
content = 
    span [id "introduction"]
        [Markdown.toHtml [] """
# Data Downloads
We provide a 100% non-redundant catalog (964,970,496 smORFs) and a 90% amino-acid level catalog (287,926,875 smORFs families).

- The download files contain: 
  - protein / nucleotide fasta file
  - cluster table
  - taxonomy classification
  - habitat assignment
  - quality assessment
  - conserved domain annotation
  - cellular localization prediction
  - metadata
___
##### Protein sequence(.fasta)
Fasta file of 100AA / 90AA protein sequences.

**100AA catalog:**&emsp;[GMSC10.100AA.faa.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.faa.xz](https://gmgc.embl.de/download.cgi)
___
##### Nucleotide sequence(.fasta)
Fasta file of 100AA / 90AA nucleotide sequences.

**100AA catalog:**&emsp;[GMSC10.100AA.fna.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.fna.xz](https://gmgc.embl.de/download.cgi)
___
##### Clusters
TSV table relating 100AA smORF accession and the hierarchically obtained clusters at 90% amino acid identity (which represent sequences with the same function).

Columns:

- 100AA smORF accession
- 90AA smORF accession

**Protein clustering table:**&emsp;[GMSC10.cluster.tsv.xz](https://gmgc.embl.de/download.cgi)
___
##### Taxonomy classification
TSV table relating the taxonomy classification of 100AA / 90AA catalog.

Columns:

- smORF accession
- taxonomy (separated by `;`)

**100AA catalog:**&emsp;[GMSC10.100AA.taxonomy.tsv.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.taxonomy.tsv.xz](https://gmgc.embl.de/download.cgi)
___
##### Habitat assignment
description

**100AA catalog:**&emsp;[GMSC10.100AA.habitat.tsv.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.habitat.tsv.xz](https://gmgc.embl.de/download.cgi)
___
##### Quality assessment
description

**100AA catalog:**&emsp;[GMSC10.100AA.quality.tsv.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.quality.tsv.xz](https://gmgc.embl.de/download.cgi)
___
##### Conserved domain annotation
description

**100AA catalog:**&emsp;[GMSC10.100AA.cdd.tsv.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.cdd.tsv.xz](https://gmgc.embl.de/download.cgi)
___
##### cellular localization prediction
description

**100AA catalog:**&emsp;[GMSC10.100AA.transmemrane-secreted.tsv.xz](https://gmgc.embl.de/download.cgi)

**90AA catalog:**&emsp;[GMSC10.90AA.transmemrane-secreted.tsv.xz](https://gmgc.embl.de/download.cgi)
___
##### Metadata
description

**Metadata:**&emsp;[GMSC10.metadata.tsv.xz](https://gmgc.embl.de/download.cgi)
"""]


-- header


header : Html msg
header =
    let
        link target name =
            Grid.col []
                     [Html.a [href target] [Html.text name]
                     ]
    in div
        [id "topbar"]
        [Grid.simpleRow
            [ link "/home/" "Home"
            , link "/browse_data/" "Browse"
            , link "/downloads/" "Downloads"
            , link "/help/" "Help"
            , link "/about/" "About&Contact"
            ]
        ]

-- FOOTER


footer : Html msg
footer =
  div [id "footerbar"]
      [ a [][ text "Copyright (c) 2023 GMSC authors. All rights reserved."]
      ]