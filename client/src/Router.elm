module Router
    exposing
        ( init
        , update
        , Model
        , Route
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


type alias Params =
    { roomId : String
    , playerId : String
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        route : Maybe Route
        route =
            getRoute location
    in
        Model route ! [ getCmd route ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (UrlChange location) _ =
    init location


getRoute : Navigation.Location -> Maybe Route
getRoute location =
    Debug.log "route" <| parseHash hashParser location


getCmd : Maybe Route -> Cmd Msg
getCmd route =
    case route of
        Just _ ->
            Cmd.none

        _ ->
            Navigation.newUrl "#/"


hashParser : UrlParser.Parser (Route -> a) a
hashParser =
    oneOf
        [ map Home top
        , map View <| string
        , map Play <| string </> string
        ]
