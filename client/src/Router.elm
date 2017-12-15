module Router
    exposing
        ( init
        , update
        , getRoute
        , fromLocation
        , Model
        , Route(..)
        , Msg(SetRoute)
        )

import Navigation
import UrlParser exposing ((</>), top, s, string, oneOf, map, parseHash)
import Data.Game exposing (GameId)
import Data.Player exposing (PlayerId)
import Utils exposing (homeUrl)


type Route
    = NotFound
    | Home
    | View GameId
    | Play GameId PlayerId


type Msg
    = SetRoute (Maybe Route)


type Model
    = Model (Maybe Route)


init : Maybe Route -> ( Model, Cmd Msg )
init maybeRoute =
    Model maybeRoute ! [ redirectIfNeeded maybeRoute ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (SetRoute maybeRoute) _ =
    init maybeRoute


redirectIfNeeded : Maybe Route -> Cmd Msg
redirectIfNeeded maybeRoute =
    maybeRoute
        |> Maybe.map (always <| Cmd.none)
        |> Maybe.withDefault (Navigation.newUrl homeUrl)


fromLocation : Navigation.Location -> Maybe Route
fromLocation location =
    parseHash routeParser location


getRoute : Model -> Route
getRoute (Model maybeRoute) =
    maybeRoute
        |> Maybe.withDefault NotFound


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home <| s ""
        , map View <| string
        , map Play <| string </> string
        ]
