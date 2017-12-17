module Main exposing (..)

import Html exposing (..)
import Navigation
import Material
import Material.Grid as Grid
import Material.Scheme as Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Options as Options
import Material.Icon as Icon
import Pages.Home as HomePage
import Pages.View as ViewPage
import Pages.Play as PlayPage
import Router
import Utils exposing (homeUrl)


type Msg
    = SetRoute (Maybe Router.Route)
    | RouterMsg Router.Msg
    | PageMsg InternalPageMsg
    | Mdl (Material.Msg Msg)
    | ToggleDrawer


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
    , mdl : Material.Model
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
        Model router page Material.model
            ! [ Cmd.map RouterMsg routerCmd
              , pageCmd
              , Layout.sub0 Mdl
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ router, page, mdl } as model) =
    case msg of
        SetRoute maybeRoute ->
            let
                ( router_, cmd ) =
                    Router.update (Router.SetRoute maybeRoute) router

                ( page_, pageCmd ) =
                    getPage <| Router.getRoute router_
            in
                Model router_ page_ mdl
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

        Mdl mdlMsg ->
            let
                ( model_, cmd ) =
                    Material.update Mdl mdlMsg model
            in
                model_ ! [ cmd ]

        ToggleDrawer ->
            let
                ( model_, cmd ) =
                    update (Layout.toggleDrawer Mdl) model
            in
                model_ ! [ cmd ]


view : Model -> Html Msg
view { page, mdl } =
    let
        title : Html Msg
        title =
            Layout.title [] [ text "Trivia" ]

        header : Html Msg
        header =
            Layout.row [] [ title ]

        navIcon : String -> Html never
        navIcon iconType =
            Icon.view iconType [ Options.css "marginRight" ".25em" ]

        navigation : Html Msg
        navigation =
            Layout.navigation []
                [ Layout.link
                    [ Layout.href homeUrl
                    , Options.onClick ToggleDrawer
                    ]
                    [ navIcon "home"
                    , text "Home page"
                    ]
                , Layout.link
                    [ Layout.href "https://github.com/rkrupinski/trivia" ]
                    [ navIcon "code"
                    , text "Browse source"
                    ]
                ]

        currentPage : Html Msg
        currentPage =
            case page of
                Home homeModel ->
                    Html.map (toPageMsg HomeMsg) (HomePage.view homeModel)

                View viewModel ->
                    Html.map (toPageMsg ViewMsg) (ViewPage.view viewModel)

                Play playModel ->
                    Html.map (toPageMsg PlayMsg) (PlayPage.view playModel)

                _ ->
                    text ""

        layout : Html Msg -> Html Msg
        layout contents =
            Grid.grid
                [ Options.css "maxWidth" "960px"
                ]
                [ Grid.cell
                    [ Grid.size Grid.All 12 ]
                    [ contents ]
                ]
    in
        Scheme.topWithScheme Color.BlueGrey Color.Red <|
            Layout.render Mdl
                mdl
                [ Layout.fixedHeader ]
                { header = [ header ]
                , drawer =
                    [ title
                    , navigation
                    ]
                , tabs = ( [], [] )
                , main = [ layout currentPage ]
                }


subscriptions : Model -> Sub Msg
subscriptions { mdl } =
    Sub.batch [ Layout.subs Mdl mdl ]


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
            let
                ( model, cmd ) =
                    ViewPage.init gameId
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
