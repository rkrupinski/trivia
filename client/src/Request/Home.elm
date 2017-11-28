module Request.Home exposing (newGame)

import Http
import HttpBuilder
import Data.Game as Game exposing (Game)


newGame : Http.Request Game
newGame =
    "http://localhost:4000/games"
        |> HttpBuilder.post
        |> HttpBuilder.withExpect (Http.expectJson Game.decoder)
        |> HttpBuilder.toRequest
