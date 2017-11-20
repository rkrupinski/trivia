module Main exposing (..)

import Html exposing (..)
import Navigation
import Router


type Msg
    = RouterMsg Router.Msg
    | UrlChange Navigation.Location


type alias Model =
    { router : Router.Model
    }


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
    let
        ( router, cmd ) =
            Router.init location
    in
        { router = router
        }
            ! [ Cmd.map RouterMsg cmd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ router } as model) =
    case msg of
        UrlChange location ->
            let
                ( router_, cmd ) =
                    Router.update (Router.UrlChange location) router
            in
                { model
                    | router = router_
                }
                    ! [ Cmd.map RouterMsg cmd ]

        RouterMsg routerMsg ->
            let
                ( router_, cmd ) =
                    Router.update routerMsg router
            in
                { model
                    | router = router_
                }
                    ! [ Cmd.map RouterMsg cmd ]


view : Model -> Html Msg
view model =
    p [] [ text "Trivia" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
