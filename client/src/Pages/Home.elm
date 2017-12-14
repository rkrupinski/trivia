module Pages.Home
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Navigation
import Request.Game exposing (newGame)
import Data.Game exposing (Game)


type Model
    = Model
        { pending : Bool
        }


type Msg
    = NewGame
    | GameCreated (Result Http.Error Game)


init : ( Model, Cmd Msg )
init =
    Model
        { pending = False
        }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
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
                ! [ Navigation.newUrl <| "#/" ++ id ]

        GameCreated (Err err) ->
            Model
                { model
                    | pending = False
                }
                ! []


view : Model -> Html Msg
view (Model { pending }) =
    div []
        [ h1 [] [ text "Trivia" ]
        , button
            [ onClick NewGame
            , disabled pending
            ]
            [ text "New game" ]
        ]
