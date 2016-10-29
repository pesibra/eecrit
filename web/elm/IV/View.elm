module IV.View exposing (view)

import Animation
import Html exposing (..)
import Html.Attributes as Attr
import Svg
import Svg.Attributes exposing (..)
import IV.Pile.HtmlShorthand exposing (..)

import IV.Main exposing (Model)
import IV.Msg exposing (Msg)
import IV.Scenario.View as Scenario
import IV.Apparatus.View as Apparatus
import IV.Clock.View as Clock

everything = {width = "400px", height = "700px"}
graphics = {width = "400px", height = "400px"}

mainDiv : List (Html msg) -> Html msg
mainDiv contents = 
  div
  [ Attr.style [ ( "margin", "0px auto" )
               , ( "width", everything.width )
               , ( "height", everything.height )
               , ( "cursor", "pointer" )
               ]
  ]
  contents

mainSvg contents  =
  row [ ]
    [ hr [] []
    , Svg.svg
        [ version "1.1"
        , x "0"
        , y "0"
        , Svg.Attributes.width graphics.width
        , Svg.Attributes.height graphics.height
        ]
        contents
    ]

view : Model -> Html Msg
view model =
  mainDiv
  [ Scenario.choices model.scenario
  , viewEditor model.scenarioEditorState
  , mainSvg (Apparatus.render model.apparatus ++ Clock.render model.clock)
  , Scenario.view model.scenario
  ]


viewEditor animationState = 
  row
    (Animation.render animationState
       ++ [Attr.style
             [ ("border", "2px solid #AAA")
             , ("opacity", "1.0")
             ]
          ])
    [ p [] [text "here is some text"]
    , p [] [text "here is some text"]
    , p [] [text "here is some text"]
    ]
  
