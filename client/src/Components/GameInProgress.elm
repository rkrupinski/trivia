module Components.GameInProgress
    exposing
        ( view
        )

import Html exposing (..)
import Material.Options as Options
import Material.Typography as Typography


view : Html never
view =
    Options.styled p
        [ Typography.headline ]
        [ text "Game in progress 🎮" ]
