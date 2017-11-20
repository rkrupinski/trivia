module Main exposing (..)

import Html exposing (..)
import Navigation


type Msg
    = UrlChange Navigation.Location


type alias Model =
    {}


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    {} ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []


view : Model -> Html Msg
view model =
    p [] [ text "Trivia" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
