module SiteMarkdown exposing (mdToHtml)

import Markdown
import Html

type MDFiletype =
    BlogPost | RegularPage

type alias MarkdownFile =
    { path : String
    , spath : List String
    , slug : String
    }

replaceBaseUrl body =
    body
        |> String.replace "{{ site.baseurl }}" ""
        |> String.replace "{{site.baseurl}}" ""

mdToHtml body = Html.div [] (Markdown.toHtml)
