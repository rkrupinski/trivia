module Components.JoinGame
    exposing
        ( Model
        , Msg
        , init
        , view
        , update
        )

import Html exposing (..)


type Model
    = Model {}


type Msg
    = Noop


init : Model
init =
    Model {}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    Model model ! []


view : Model -> Html Msg
view _ =
    text "Render join form \x1F57A"
