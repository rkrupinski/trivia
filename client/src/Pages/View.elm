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
import Components.GameInProgress as GameInProgress
import Components.Summary as Summary


type Model
    = Model
        { gameData : WebData Game
        , joinGame : JoinGame.Model
        }


type Msg
    = GameData (WebData Game)
    | JoinGameMsg JoinGame.Msg


init : GameId -> ( Model, Cmd Msg )
init gameId =
    Model
        { gameData = Loading
        , joinGame = JoinGame.init gameId
        }
        ! [ gameData gameId
                |> sendRequest
                |> Cmd.map GameData
          ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model ({ gameData, joinGame } as model)) =
    case msg of
        GameData response ->
            Model
                { model
                    | gameData = response
                }
                ! []

        JoinGameMsg joinGameMsg ->
            let
                ( joinGame_, cmd ) =
                    JoinGame.update joinGameMsg joinGame
            in
                Model
                    { model
                        | joinGame = joinGame_
                    }
                    ! [ Cmd.map JoinGameMsg cmd ]


view : Model -> Html Msg
view (Model { gameData, joinGame }) =
    let
        pageContent : Html Msg
        pageContent =
            case gameData of
                Success { can_join, status } ->
                    case ( can_join, status ) of
                        ( True, _ ) ->
                            Html.map JoinGameMsg <| JoinGame.view joinGame

                        ( False, Game.Started ) ->
                            GameInProgress.view

                        _ ->
                            Summary.view

                _ ->
                    text ""
    in
        div [] [ pageContent ]
