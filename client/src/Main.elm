module Main exposing (..)

import Html exposing (..)
import Navigation
import Pages.Home as HomePage
import Router


type Msg
    = SetRoute (Maybe Router.Route)
    | RouterMsg Router.Msg


type Page
    = Home HomePage.Model


type alias Model =
    { router : Router.Model
    }


main : Program Never Model Msg
main =
    Navigation.program (Router.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( router, cmd ) =
            Router.init <| Router.fromLocation location
    in
        Model router
            ! [ Cmd.map RouterMsg cmd
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ router } as model) =
    case msg of
        SetRoute maybeRoute ->
            let
                ( router_, cmd ) =
                    Router.update (Router.SetRoute maybeRoute) router
            in
                Model router_ ! [ Cmd.map RouterMsg cmd ]

        RouterMsg _ ->
            -- ¯\_(ツ)_/¯
            model ! []


view : Model -> Html Msg
view { router } =
    let
        route : Router.Route
        route =
            Router.getRoute router
    in
        case route of
            Router.Home ->
                p [] [ text "Home" ]

            Router.View gameId ->
                p [] [ text <| "View: " ++ gameId ]

            Router.Play gameId playerId ->
                p [] [ text <| "Play: " ++ gameId ++ playerId ]

            _ ->
                text ""


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
