module Request.Game
    exposing
        ( newGame
        , gameData
        )

import Http
import HttpBuilder
import Data.Game exposing (Game, GameId, gameDecoder)
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
    "/games/"
        |> flip (++) gameId
        |> apiUrl
        |> HttpBuilder.get
        |> HttpBuilder.withExpect (Http.expectJson gameDecoder)
        |> HttpBuilder.toRequest
