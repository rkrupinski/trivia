module Request.Home exposing (newGame)

import Http
import HttpBuilder
import Data.Game as Game exposing (Game)
import Request.Helpers exposing (apiUrl)


newGame : Http.Request Game
newGame =
    "/games"
        |> apiUrl
        |> HttpBuilder.post
        |> HttpBuilder.withExpect (Http.expectJson Game.decoder)
        |> HttpBuilder.toRequest
