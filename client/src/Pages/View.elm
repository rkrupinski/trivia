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
import Material
import Material.Spinner as Loading
import Data.Game as Game exposing (GameId, Game)
import Request.Game exposing (gameData)
import Components.JoinGame as JoinGame
import Components.GameInProgress as GameInProgress
import Components.Summary as Summary


type Model
    = Model
        { gameData : WebData Game
        , joinGame : JoinGame.Model
        , mdl : Material.Model
        }


type Msg
    = GameData (WebData Game)
    | JoinGameMsg JoinGame.Msg
    | Mdl (Material.Msg Msg)


init : GameId -> ( Model, Cmd Msg )
init gameId =
    Model
        { gameData = Loading
        , joinGame = JoinGame.init gameId
        , mdl = Material.model
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

        Mdl mdlMsg ->
            let
                ( model_, cmd ) =
                    Material.update Mdl mdlMsg model
            in
                Model model_ ! [ cmd ]


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

                Loading ->
                    Loading.spinner [ Loading.active True ]

                _ ->
                    text ""
    in
        div [] [ pageContent ]
