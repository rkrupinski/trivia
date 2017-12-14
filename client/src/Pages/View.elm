module Pages.View
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        )

import Html exposing (..)
import Http
import Data.Game exposing (GameId, Game)
import Request.Game exposing (gameData)


type Model
    = Model (Maybe Game)


type Msg
    = GameData (Result Http.Error Game)


init : GameId -> ( Model, Cmd Msg )
init gameId =
    Model Nothing
        ! [ Http.send GameData <| gameData gameId ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GameData (Ok game) ->
            Model (Just game) ! []

        GameData (Err _) ->
            Model Nothing ! []


view : Model -> Html Msg
view model =
    p [] [ text <| "View: " ++ (toString model) ]
