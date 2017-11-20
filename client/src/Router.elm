module Router
    exposing
        ( init
        , update
        , getRoute
        , Model
        , Route(..)
        , Msg(UrlChange)
        )

import Navigation
import UrlParser exposing ((</>), top, string, oneOf, map, parseHash)


type Route
    = Home
    | View String
    | Play String String


type Msg
    = UrlChange Navigation.Location


type Model
    = Model (Maybe Route)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        route : Maybe Route
        route =
            computeRoute location

        cmd : Cmd Msg
        cmd =
            case route of
                Just _ ->
                    Cmd.none

                _ ->
                    Navigation.newUrl "#/"
    in
        Model route ! [ cmd ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (UrlChange location) _ =
    init location


computeRoute : Navigation.Location -> Maybe Route
computeRoute location =
    Debug.log "route" <| parseHash hashParser location


getRoute : Model -> Maybe Route
getRoute (Model route) =
    route


hashParser : UrlParser.Parser (Route -> a) a
hashParser =
    oneOf
        [ map Home top
        , map View <| string
        , map Play <| string </> string
        ]
