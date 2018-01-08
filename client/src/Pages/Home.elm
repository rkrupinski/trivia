module Pages.Home
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        )

import Html exposing (..)
import Http
import Navigation
import Material
import Material.Button as Button
import Material.Options as Options
import Material.Typography as Typography
import Request.Game exposing (newGame)
import Data.Game exposing (Game)
import Utils exposing (gameUrl)


type Model
    = Model
        { pending : Bool
        , mdl : Material.Model
        }


type Msg
    = NewGame
    | GameCreated (Result Http.Error Game)
    | Mdl (Material.Msg Msg)


init : ( Model, Cmd Msg )
init =
    Model
        { pending = False
        , mdl = Material.model
        }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model ({ mdl } as model)) =
    case msg of
        NewGame ->
            Model
                { model
                    | pending = True
                }
                ! [ Http.send GameCreated newGame ]

        GameCreated (Ok { id }) ->
            Model
                { model
                    | pending = False
                }
                ! [ Navigation.newUrl <| gameUrl id ]

        GameCreated (Err err) ->
            -- TODO: Error handling
            Model
                { model
                    | pending = False
                }
                ! []

        Mdl mdlMsg ->
            let
                ( model_, cmd ) =
                    Material.update Mdl mdlMsg model
            in
                Model model_ ! [ cmd ]


view : Model -> Html Msg
view (Model { pending, mdl }) =
    div []
        [ Options.styled p
            [ Typography.headline ]
            [ text "Create a new game" ]
        , Button.render Mdl
            [ 0 ]
            mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Options.onClick NewGame
            , Options.disabled pending
            ]
            [ text "Create" ]
        ]
