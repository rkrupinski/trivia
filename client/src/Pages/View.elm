module Pages.View
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        )

import Html exposing (..)
import RemoteData exposing (..)
import Data.Game as Game exposing (GameId, Game)
import Request.Game exposing (gameData)
import Components.JoinGame as JoinGame


type Model
    = Model (WebData Game) (Maybe JoinGame.Model)


type Msg
    = GameData (WebData Game)
    | JoinGameMsg JoinGame.Msg


init : GameId -> ( Model, Cmd Msg )
init gameId =
    Model Loading Nothing
        ! [ gameData gameId
                |> sendRequest
                |> Cmd.map GameData
          ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model gameData joinGame) =
    case msg of
        GameData response ->
            Model response joinGame ! []

        JoinGameMsg joinGameMsg ->
            let
                ( joinGame_, cmd ) =
                    joinGame
                        |> ensureJoinGame
                        |> JoinGame.update joinGameMsg
            in
                Model gameData (Just joinGame_)
                    ! [ Cmd.map JoinGameMsg cmd ]


view : Model -> Html Msg
view (Model gameData joinGame) =
    case gameData of
        Success { can_join, status } ->
            case ( can_join, status ) of
                ( True, _ ) ->
                    Html.map JoinGameMsg
                        (joinGame
                            |> ensureJoinGame
                            |> JoinGame.view
                        )

                ( False, Game.Started ) ->
                    text "Game in progress"

                _ ->
                    text "Display results"

        _ ->
            text ""


ensureJoinGame : Maybe JoinGame.Model -> JoinGame.Model
ensureJoinGame =
    Maybe.withDefault JoinGame.init
