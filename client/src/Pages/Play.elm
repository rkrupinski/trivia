module Pages.Play
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        )

import Html exposing (..)


type Model
    = Model {}


type Msg
    = Noop


init : ( Model, Cmd Msg )
init =
    Model
        {}
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    Model model ! []


view : Model -> Html Msg
view model =
    p [] [ text <| "Play: " ++ (toString model) ]
