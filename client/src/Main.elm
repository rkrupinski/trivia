module Main exposing (..)

import Html exposing (..)
import Navigation
import Pages.Home as HomePage
import Router


type Msg
    = HomePageMsg HomePage.Msg
    | RouterMsg Router.Msg
    | UrlChange Navigation.Location


type alias Model =
    { homePage : HomePage.Model
    , router : Router.Model
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
        ( homePage, homePageCmd ) =
            HomePage.init

        ( router, routerCmd ) =
            Router.init location
    in
        Model homePage router
            ! [ Cmd.map HomePageMsg homePageCmd
              , Cmd.map RouterMsg routerCmd
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ homePage, router } as model) =
    case msg of
        HomePageMsg homePageMsg ->
            let
                ( homePage_, cmd ) =
                    HomePage.update homePageMsg homePage
            in
                { model
                    | homePage = homePage_
                }
                    ! [ Cmd.map HomePageMsg cmd ]

        RouterMsg routerMsg ->
            let
                ( router_, cmd ) =
                    Router.update routerMsg router
            in
                { model
                    | router = router_
                }
                    ! [ Cmd.map RouterMsg cmd ]

        UrlChange location ->
            let
                ( router_, cmd ) =
                    Router.update (Router.UrlChange location) router
            in
                { model
                    | router = router_
                }
                    ! [ Cmd.map RouterMsg cmd ]


view : Model -> Html Msg
view { homePage, router } =
    let
        route : Maybe Router.Route
        route =
            Router.getRoute router
    in
        case route of
            Just (Router.Home) ->
                Html.map HomePageMsg <| HomePage.view homePage

            Just (Router.View gameId) ->
                p [] [ text <| "View: " ++ gameId ]

            Just (Router.Play gameId playerId) ->
                p [] [ text <| "Play: " ++ gameId ++ playerId ]

            _ ->
                text ""


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
