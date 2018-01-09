module Components.GameInProgress
    exposing
        ( render
        )

import Html exposing (..)
import Material.Options as Options
import Material.Typography as Typography


render : Html never
render =
    Options.styled p
        [ Typography.headline ]
        [ text "Game in progress 🎮" ]
