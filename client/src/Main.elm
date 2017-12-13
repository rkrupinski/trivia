module Main exposing (..)

import Html exposing (..)
import Navigation
import Pages.Home as HomePage
import Pages.View as ViewPage
import Pages.Play as PlayPage
import Router


type Msg
    = SetRoute (Maybe Router.Route)
    | RouterMsg Router.Msg
    | PageMsg InternalPageMsg


type InternalPageMsg
    = HomeMsg HomePage.Msg
    | ViewMsg ViewPage.Msg
    | PlayMsg PlayPage.Msg


type Page
    = Home HomePage.Model
    | View ViewPage.Model
    | Play PlayPage.Model
    | NotFound


type alias Model =
    { router : Router.Model
    , page : Page
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
        ( router, routerCmd ) =
            Router.init <| Router.fromLocation location

        ( page, pageCmd ) =
            getPage <| Router.getRoute router
    in
        Model router page
            ! [ Cmd.map RouterMsg routerCmd
              , pageCmd
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ router, page } as model) =
    case msg of
        SetRoute maybeRoute ->
            let
                ( router_, cmd ) =
                    Router.update (Router.SetRoute maybeRoute) router

                ( page_, pageCmd ) =
                    getPage <| Router.getRoute router_
            in
                Model router_ page_
                    ! [ Cmd.map RouterMsg cmd
                      , pageCmd
                      ]

        RouterMsg routerMsg ->
            -- ¯\_(ツ)_/¯
            model ! []

        PageMsg internalPageMsg ->
            let
                ( page_, pageCmd ) =
                    updatePage page internalPageMsg
            in
                { model
                    | page = page_
                }
                    ! [ pageCmd ]


view : Model -> Html Msg
view { page } =
    case page of
        Home homeModel ->
            Html.map (toPageMsg HomeMsg) <| HomePage.view homeModel

        View viewModel ->
            p [] [ text <| "View: " ++ (toString viewModel) ]

        Play playModel ->
            p [] [ text <| "Play: " ++ (toString playModel) ]

        _ ->
            text ""


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getPage : Router.Route -> ( Page, Cmd Msg )
getPage route =
    case route of
        Router.Home ->
            let
                ( model, cmd ) =
                    HomePage.init
            in
                ( Home model, Cmd.map (toPageMsg HomeMsg) cmd )

        Router.View gameId ->
            -- TODO: init with GameId
            let
                ( model, cmd ) =
                    ViewPage.init
            in
                ( View model, Cmd.map (toPageMsg ViewMsg) cmd )

        Router.Play gameId playerId ->
            -- TODO: init with GameId & PlayerId
            let
                ( model, cmd ) =
                    PlayPage.init
            in
                ( Play model, Cmd.map (toPageMsg PlayMsg) cmd )

        _ ->
            ( NotFound, Cmd.none )


updatePage : Page -> InternalPageMsg -> ( Page, Cmd Msg )
updatePage page msg =
    case ( page, msg ) of
        ( Home homeModel, HomeMsg homeMsg ) ->
            let
                ( model, cmd ) =
                    HomePage.update homeMsg homeModel
            in
                ( Home model, Cmd.map (toPageMsg HomeMsg) cmd )

        ( View viewModel, ViewMsg viewMsg ) ->
            let
                ( model, cmd ) =
                    ViewPage.update viewMsg viewModel
            in
                ( View model, Cmd.map (toPageMsg ViewMsg) cmd )

        ( Play playModel, PlayMsg playMsg ) ->
            let
                ( model, cmd ) =
                    PlayPage.update playMsg playModel
            in
                ( Play model, Cmd.map (toPageMsg PlayMsg) cmd )

        _ ->
            ( page, Cmd.none )


toPageMsg : (a -> InternalPageMsg) -> (a -> Msg)
toPageMsg internalPageMsg =
    PageMsg << internalPageMsg
