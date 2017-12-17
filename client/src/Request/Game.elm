module Request.Game
    exposing
        ( newGame
        , gameData
        , joinGame
        )

import Http
import HttpBuilder
import Json.Encode as Encode
import Data.Game exposing (Game, GameId, gameDecoder)
import Data.Player exposing (PlayerName, Joined, joinedDecoder)
import Request.Helpers exposing (apiUrl)


newGame : Http.Request Game
newGame =
    "/games"
        |> apiUrl
        |> HttpBuilder.post
        |> HttpBuilder.withExpect (Http.expectJson gameDecoder)
        |> HttpBuilder.toRequest


gameData : GameId -> Http.Request Game
gameData gameId =
    ("/games/" ++ gameId)
        |> apiUrl
        |> HttpBuilder.get
        |> HttpBuilder.withExpect (Http.expectJson gameDecoder)
        |> HttpBuilder.toRequest


joinGame : GameId -> PlayerName -> Http.Request Joined
joinGame gameId playerName =
    ("/games/" ++ gameId ++ "/join")
        |> apiUrl
        |> HttpBuilder.post
        |> HttpBuilder.withJsonBody (joinGameBody playerName)
        |> HttpBuilder.withExpect (Http.expectJson joinedDecoder)
        |> HttpBuilder.toRequest


joinGameBody : PlayerName -> Encode.Value
joinGameBody playerName =
    Encode.object [ ( "playerName", Encode.string playerName ) ]
